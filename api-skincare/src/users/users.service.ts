import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';
import { Product } from '../product/interfaces/product.interface';
import { Routine } from '../routines/interfaces/routine.interface';
import { CloudinaryService } from '../cloudinary/cloudinary.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel('Users') private readonly userModel: Model<User>,
    @InjectModel('Product') private productModel: Model<Product>,
    @InjectModel('Routine') private routineModel: Model<Routine>,
    private cloudinaryService: CloudinaryService,
  ) {}

  // REGISTER
  async create(createUserDto: CreateUserDto): Promise<User> {
    const emailExists = await this.userModel.findOne({
      email: createUserDto.email.toLowerCase(),
    });
    if (emailExists) {
      throw new ConflictException('El email ya está registrado');
    }

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);

    const newUser = new this.userModel({
      ...createUserDto,
      email: createUserDto.email.toLowerCase(),
      password: hashedPassword,
    });

    return newUser.save();
  }

  // LOGIN — igual que tu findOne anterior
  async findOne(condition: any): Promise<User | null> {
    return this.userModel.findOne(condition).exec();
  }

  // VER PERFIL
  async findById(id: string): Promise<User | null> {
    return this.userModel.findById(id).exec();
  }

  // VER TODOS PERFILES
  async getAllUsers(): Promise<User[]> {
    return this.userModel.find().select('-password').exec();
  }

  // EDITAR
  async update(id: string, updateUserDto: UpdateUserDto): Promise<User | null> {
    if (updateUserDto.email) {
      const emailExists = await this.userModel.findOne({
        email: updateUserDto.email.toLowerCase(),
        _id: { $ne: id },
      });
      if (emailExists) {
        throw new ConflictException(
          'El email ya está registrado por otro usuario',
        );
      }
      updateUserDto.email = updateUserDto.email.toLowerCase();
    }

    // Hashear password si viene
    if (updateUserDto.password) {
      updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
    }

    // Convertir birthDate si viene
    if (updateUserDto.birthDate) {
      updateUserDto.birthDate = new Date(updateUserDto.birthDate);
    }

    const updated = await this.userModel
      .findByIdAndUpdate(id, updateUserDto, { returnDocument: 'after' })
      .select('-password')
      .exec();

    if (!updated) {
      throw new NotFoundException(`Usuario ${id} no encontrado`);
    }
    return updated;
  }

  // ELIMINAR
  async delete(id: string): Promise<User | null> {
    // 1. Obtener el usuario (para acceder a su profileImage)
    const user = await this.userModel.findById(id);
    if (!user) {
      throw new NotFoundException(`Usuario ${id} no encontrado`);
    }

    // 2. Obtener todos los productos del usuario (para eliminar sus imágenes)
    const products = await this.productModel
      .find({ userId: id })
      .select('imageUrl')
      .exec();

    // 3. Eliminar imágenes de Cloudinary (productos)
    for (const product of products) {
      if (product.imageUrl) {
        const publicId = this.cloudinaryService.extractPublicIdFromUrl(
          product.imageUrl,
        );
        if (publicId) {
          await this.cloudinaryService.deleteImage(publicId);
          console.log(`🗑️ Imagen de producto eliminada: ${publicId}`);
        }
      }
    }

    // 4. Eliminar imagen de perfil del usuario
    if (user.profileImage) {
      const publicId = this.cloudinaryService.extractPublicIdFromUrl(
        user.profileImage,
      );
      if (publicId) {
        await this.cloudinaryService.deleteImage(publicId);
        console.log(`🗑️ Imagen de perfil eliminada: ${publicId}`);
      }
    }

    // 5. Eliminar documentos de la BD
    await this.productModel.deleteMany({ userId: id });
    await this.routineModel.deleteMany({ userId: id });
    const deletedUser = await this.userModel
      .findByIdAndDelete(id)
      .select('-password')
      .exec();

    return deletedUser;
  }
}
