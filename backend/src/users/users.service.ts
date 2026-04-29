import {
  Injectable,
  NotFoundException,
  ConflictException, BadRequestException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';
import { Product } from '../product/interfaces/product.interface';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { ImageCompressionService } from '../services/image-compression.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel('Users') private readonly userModel: Model<User>,
    @InjectModel('Product') private productModel: Model<Product>,
    private cloudinaryService: CloudinaryService,
    private readonly imageCompressionService: ImageCompressionService,
  ) {}

  // extrae la url de la imagen de perfil para eliminarla de la nube
  private async deleteCloudinaryImageByUrl(imageUrl?: string | null, logPrefix?: string) {
    if (!imageUrl) return;
    const publicId = this.cloudinaryService.extractPublicIdFromUrl(imageUrl);
    if (!publicId) return;
    await this.cloudinaryService.deleteImage(publicId);
    if (logPrefix) console.log(`${logPrefix}: ${publicId}`);
  }

  // crea un usuario (registro). calida email unico y guarda contra hasheada
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

  // busca usuario segun lo que pide el login -> email
  async findOne(condition: any): Promise<User | null> {
    return this.userModel.findOne(condition).exec();
  }

  // obtiene y muestra usuario segun su id
  async findById(id: string): Promise<User | null> {
    return this.userModel.findById(id).exec();
  }

  // lista a todos los usuarios registrados sin mostrar la contraseña
  async getAllUsers(): Promise<User[]> {
    return this.userModel.find().select('-password').exec();
  }

  // actualiza info de perfil -> hashea password si viene, reellena o vacia el tlf y cumple
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
    if (updateUserDto.password) {
      updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
    }
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

  // elimina al usuario y todos los archivos relacionados con este
  // foto de perfil, productos, rutinas... en cascada
  async delete(id: string): Promise<User | null> {
    const user = await this.userModel.findById(id);
    if (!user) {
      throw new NotFoundException(`Usuario ${id} no encontrado`);
    }
    const products = await this.productModel
      .find({ userId: id })
      .select('imageUrl')
      .exec();
    for (const product of products) {
      await this.deleteCloudinaryImageByUrl(
        product.imageUrl,
        '🗑️ Imagen de producto eliminada',
      );
    }
    await this.deleteCloudinaryImageByUrl(
      user.profileImage,
      '🗑️ Imagen de perfil eliminada',
    );

    await this.productModel.deleteMany({ userId: id });
    const deletedUser = await this.userModel
      .findByIdAndDelete(id)
      .select('-password')
      .exec();

    return deletedUser;
  }

  // elimina la foto de Cloudinary y limpia la URL del usuario
  async deleteProfileImage(userId: string): Promise<User> {
    const user = await this.findById(userId);
    if (!user) {
      throw new NotFoundException('Usuario no encontrado');
    }
    if (!user.profileImage) {
      throw new BadRequestException('No hay imagen de perfil para eliminar');
    }
    await this.deleteCloudinaryImageByUrl(
      user.profileImage,
      '🗑️ Imagen de perfil eliminada de Cloudinary',
    );

    const updatedUser = await this.update(userId, { profileImage: null });
    if (!updatedUser) {
      throw new NotFoundException(`Usuario ${userId} no encontrado`);
    }
    return updatedUser;
  }

  // sube comprimiendo la foto de perfil, borrando la anterior y subiendola a Cloudinary
  async updateProfileImage(
    userId: string,
    fileBuffer: Buffer,
    mimeType: string
  ): Promise<User> {
    const compressedBuffer = await this.imageCompressionService.compressProfileImage(
      fileBuffer,
      mimeType
    );
    const imageUrl = await this.cloudinaryService.uploadImage(
      compressedBuffer,
      `${userId}_profile_${Date.now()}`,
      'user-profiles'
    );
    const currentUser = await this.findById(userId);
    await this.deleteCloudinaryImageByUrl(
      currentUser?.profileImage,
      '🗑️ Imagen anterior eliminada',
    );
    const updatedUser = await this.update(userId, { profileImage: imageUrl });
    if (!updatedUser) {
      throw new NotFoundException(`Usuario ${userId} no encontrado`);
    }
    console.log(`✅ Imagen de perfil actualizada para usuario ${userId}`);
    return updatedUser;
  }
}