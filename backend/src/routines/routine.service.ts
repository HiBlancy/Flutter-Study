import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Routine } from './interfaces/routine.interface';
import { CreateRoutineDto } from './dto/create-routine.dto';
import { UpdateRoutineDto } from './dto/update-routine.dto';
import { ReorderProductsDto } from './dto/reorder-products.dto';
import { Product } from '../product/interfaces/product.interface';

@Injectable()
export class RoutineService {
  constructor(
    @InjectModel('Routine') private readonly routineModel: Model<Routine>,
    @InjectModel('Product') private readonly productModel: Model<Product>,
  ) {}

  private toOrderedProducts(productIds: string[]) {
    // Convierte ["id1","id2"] => [{productId:"id1", order:0}, ...]
    return (productIds || []).map((productId, index) => ({
      productId,
      order: index,
    }));
  }

  // Crea una rutina y guarda los productos con orden (0..n).
  async create(
    userId: string,
    createRoutineDto: CreateRoutineDto,
  ): Promise<Routine> {
    // Si vienen productos, validar que existan y sean del usuario.
    if (createRoutineDto.products && createRoutineDto.products.length > 0) {
      await this.validateProducts(userId, createRoutineDto.products);
    }

    // Guardar productos con orden.
    const productsWithOrder = this.toOrderedProducts(
      createRoutineDto.products || [],
    );

    const newRoutine = new this.routineModel({
      ...createRoutineDto,
      userId,
      products: productsWithOrder,
    });

    return newRoutine.save();
  }

  async findAllByUser(userId: string): Promise<Routine[]> {
    return this.routineModel
      .find({ userId })
      .populate('products.productId')
      .sort({ createdAt: -1 })
      .exec();
  }

  async findById(id: string, userId: string): Promise<Routine | null> {
    try {
      const routine = await this.routineModel
        .findById(id)
        .populate('products.productId')
        .exec();
      if (!routine) return null;
      if (routine.userId.toString() !== userId.toString()) {
        throw new ForbiddenException(
          'No tienes permiso para acceder a esta rutina',
        );
      }
      return routine;
    } catch (error) {
      // Cualquier error se responde como 404 (comportamiento actual).
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }
  }

  async update(
    id: string,
    userId: string,
    updateRoutineDto: UpdateRoutineDto,
  ): Promise<Routine> {
    try {
      const routine = await this.routineModel.findById(id).exec();
      if (!routine) throw new NotFoundException(`Rutina ${id} no encontrada`);
      if (routine.userId.toString() !== userId.toString())
        throw new ForbiddenException();

      const updateData = Object.fromEntries(
        Object.entries(updateRoutineDto).filter(([_, v]) => v !== undefined),
      );

      // Si vienen productos, los convertimos a { productId, order } y validamos.
      if (updateData.products && Array.isArray(updateData.products)) {
        const productIds = updateData.products;
        updateData.products = this.toOrderedProducts(productIds);
        await this.validateProducts(userId, productIds);
      }

      const updated = await this.routineModel
        .findByIdAndUpdate(id, updateData, { returnDocument: 'after' })
        .populate('products.productId')
        .exec();
      if (!updated)
        throw new NotFoundException(
          `Rutina ${id} no encontrada después de actualizar`,
        );
      return updated;
    } catch (error) {
      // Cualquier error se responde como 404 (comportamiento actual).
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }
  }

  async delete(id: string, userId: string): Promise<Routine> {
    const routine = await this.routineModel.findById(id).exec();
    if (!routine) throw new NotFoundException(`Rutina ${id} no encontrada`);
    if (routine.userId.toString() !== userId.toString())
      throw new ForbiddenException(
        'No tienes permiso para eliminar esta rutina',
      );

    // Eliminar la rutina.
    const deleted = await this.routineModel.findByIdAndDelete(id).exec();
    if (!deleted)
      throw new NotFoundException(`Rutina ${id} no encontrada al eliminar`);

    return deleted;
  }

  async reorderProducts(
    id: string,
    userId: string,
    reorderDto: ReorderProductsDto,
  ): Promise<Routine> {
    try {
      const routine = await this.routineModel.findById(id).exec();
      if (!routine) throw new NotFoundException(`Rutina ${id} no encontrada`);
      if (routine.userId.toString() !== userId.toString())
        throw new ForbiddenException();

      const productIds = reorderDto.products.map((p) => p.productId);
      // Validar que los productos existan y sean del usuario.
      await this.validateProducts(userId, productIds);

      const updated = await this.routineModel
        .findByIdAndUpdate(
          id,
          { products: reorderDto.products },
          { returnDocument: 'after' },
        )
        .populate('products.productId')
        .exec();
      if (!updated) throw new NotFoundException();
      return updated;
    } catch (error) {
      // Cualquier error se responde como 404 (comportamiento actual).
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }
  }

  async addProduct(
    id: string,
    userId: string,
    productId: string,
  ): Promise<Routine> {
    const routine = await this.routineModel.findById(id).exec();
    if (!routine) {
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }

    // 2. Verificar permisos
    if (routine.userId.toString() !== userId.toString()) {
      throw new ForbiddenException(
        'No tienes permiso para actualizar esta rutina',
      );
    }

    // 3. Validar que el producto exista y pertenezca al usuario
    await this.validateProducts(userId, [productId]);

    // 4. Verificar duplicado
    const alreadyExists = routine.products.some(
      (p) => p.productId.toString() === productId,
    );
    if (alreadyExists) {
      throw new BadRequestException('Este producto ya está en la rutina');
    }

    // 5. Calcular siguiente orden
    const nextOrder =
      routine.products.length > 0
        ? Math.max(...routine.products.map((p) => p.order)) + 1
        : 0;

    // 6. Agregar producto
    routine.products.push({
      productId: productId as any,
      order: nextOrder,
    });
    await routine.save();

    // 7. Devolver rutina populada
    const populatedRoutine = await this.routineModel
      .findById(id)
      .populate('products.productId')
      .exec();

    if (!populatedRoutine) {
      throw new NotFoundException(
        `Rutina ${id} no encontrada después de agregar producto`,
      );
    }

    return populatedRoutine;
  }

  async removeProduct(
    id: string,
    userId: string,
    productId: string,
  ): Promise<Routine> {
    // 1. Buscar la rutina (con try-catch para IDs inválidos)
    let routine;
    try {
      routine = await this.routineModel.findById(id).exec();
    } catch (error) {
      // Si el ID tiene formato incorrecto (CastError), lanzamos 404
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }

    // 2. Verificar que la rutina existe
    if (!routine) {
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }

    // 3. Verificar permisos
    if (routine.userId.toString() !== userId.toString()) {
      throw new ForbiddenException(
        'No tienes permiso para modificar esta rutina',
      );
    }

    // 4. Verificar que el producto existe DENTRO de la rutina
    const productExists = routine.products.some(
      (p) => p.productId.toString() === productId,
    );
    if (!productExists) {
      throw new BadRequestException(
        `El producto ${productId} no pertenece a esta rutina`,
      );
    }

    // 5. Eliminar el producto y reordenar los restantes
    routine.products = routine.products
      .filter((p) => p.productId.toString() !== productId)
      .map((p, index) => ({
        productId: p.productId,
        order: index,
      }));

    await routine.save();

    // 6. Devolver la rutina actualizada con productos populados
    const populatedRoutine = await this.routineModel
      .findById(id)
      .populate('products.productId')
      .exec();

    if (!populatedRoutine) {
      throw new NotFoundException(
        `Rutina ${id} no encontrada después de eliminar producto`,
      );
    }

    return populatedRoutine;
  }

  private async validateProducts(
    userId: string,
    productIds: string[],
  ): Promise<void> {
    if (productIds.length === 0) return;

    const products = await this.productModel
      .find({ _id: { $in: productIds }, userId })
      .exec();

    // 404 cuando un producto no existe o no pertenece al usuario.
    if (products.length !== productIds.length) {
      throw new NotFoundException('Uno o más productos no existen');
    }
  }
}
