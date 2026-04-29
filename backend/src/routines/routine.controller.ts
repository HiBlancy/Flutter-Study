import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
  Req,
  NotFoundException,
} from '@nestjs/common';
import { RoutineService } from './routine.service';
import { CreateRoutineDto } from './dto/create-routine.dto';
import { UpdateRoutineDto } from './dto/update-routine.dto';
import { ReorderProductsDto } from './dto/reorder-products.dto';
import { AuthGuard } from '../users/guards/auth.guard';

@Controller('routines')
@UseGuards(AuthGuard)
export class RoutineController {
  constructor(private readonly routineService: RoutineService) {}

  private successResponse(message: string, data: any = null) {
    return { status: true, message, data };
  }

  // Crea una rutina (opcionalmente con productos).
  @Post()
  async create(@Req() req, @Body() createRoutineDto: CreateRoutineDto) {
    const routine = await this.routineService.create(
      req.user._id,
      createRoutineDto,
    );
    return this.successResponse('Rutina creada exitosamente', routine);
  }

  // Lista rutinas del usuario.
  @Get()
  async findAll(@Req() req) {
    const routines = await this.routineService.findAllByUser(req.user._id);
    return this.successResponse('Rutinas obtenidas', {
      data: routines,
      total: routines.length,
    });
  }

  // Obtiene una rutina por id.
  @Get(':id')
  async findOne(@Req() req, @Param('id') id: string) {
    const routine = await this.routineService.findById(id, req.user._id);
    if (!routine) {
      throw new NotFoundException(`Rutina ${id} no encontrada`);
    }
    return this.successResponse('Rutina obtenida', routine);
  }

  // Actualiza nombre/tipo/productos de una rutina.
  @Patch(':id')
  async update(
    @Req() req,
    @Param('id') id: string,
    @Body() updateRoutineDto: UpdateRoutineDto,
  ) {
    const routine = await this.routineService.update(
      id,
      req.user._id,
      updateRoutineDto,
    );
    return this.successResponse('Rutina actualizada exitosamente', routine);
  }

  // Elimina una rutina.
  @Delete(':id')
  async delete(@Req() req, @Param('id') id: string) {
    const routine = await this.routineService.delete(id, req.user._id);
    return this.successResponse('Rutina eliminada exitosamente', routine);
  }

  // Reordena los productos de una rutina.
  @Patch(':id/reorder')
  async reorderProducts(
    @Req() req,
    @Param('id') id: string,
    @Body() reorderDto: ReorderProductsDto,
  ) {
    const routine = await this.routineService.reorderProducts(
      id,
      req.user._id,
      reorderDto,
    );
    return this.successResponse('Productos reordenados exitosamente', routine);
  }

  // Agrega un producto a una rutina.
  @Post(':id/products')
  async addProduct(
    @Req() req,
    @Param('id') id: string,
    @Body('productId') productId: string,
  ) {
    const routine = await this.routineService.addProduct(
      id,
      req.user._id,
      productId,
    );
    return this.successResponse('Producto agregado a la rutina', routine);
  }

  // Elimina un producto de una rutina.
  @Delete(':id/products/:productId')
  async removeProduct(
    @Req() req,
    @Param('id') id: string,
    @Param('productId') productId: string,
  ) {
    const routine = await this.routineService.removeProduct(
      id,
      req.user._id,
      productId,
    );
    return this.successResponse('Producto eliminado de la rutina', routine);
  }
}
