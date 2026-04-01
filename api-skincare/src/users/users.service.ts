import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Document } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(@InjectModel('Users') private readonly userModel: Model<User>) {}

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
    const emailExists = await this.userModel
      .findOne({
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

  const updateData: any = { ...updateUserDto };
  if (updateUserDto.birthDate) {
    updateData.birthDate = new Date(updateUserDto.birthDate);
  }

  // Si se actualiza password, hashearla
  if (updateUserDto.password) {
    updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
  }

  const updated = await this.userModel
    .findByIdAndUpdate(id, updateUserDto, { new: true })
    .select('-password')
    .exec();

  if (!updated) {
    throw new NotFoundException(`Usuario ${id} no encontrado`);
  }
  return updated;
}

  // ELIMINAR
  async delete(id: string): Promise<User | null> {
    const deletedUser = await this.userModel
      .findByIdAndDelete(id)
      .select('-password')
      .exec();
    return deletedUser;
  }
}
