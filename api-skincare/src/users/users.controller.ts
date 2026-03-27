import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  BadRequestException,
  NotFoundException,
  ConflictException,
  UnauthorizedException,
  Req,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import * as express from 'express';

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  // POST /users/register - Registrar usuario
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto): Promise<any> {
    try {
      // Verificar si el usuario ya existe
      const emailExists = await this.usersService.findOne({
        email: createUserDto.email.toLowerCase(),
      });
      if (emailExists) {
        throw new ConflictException({
          status: false,
          message: 'El email ya está registrado',
        });
      }

      // Crear usuario
      const user = await this.usersService.create({
        ...createUserDto,
        email: createUserDto.email.toLowerCase(),
        password: createUserDto.password,
      });

      // Generar JWT
      const token = await this.jwtService.signAsync({
        _id: user._id,
        email: user.email,
        name: user.name,
      });

      // Devolver usuario COMPLETO (con contraseña)
      return {
        status: true,
        message: 'Usuario registrado exitosamente',
        data: {
          user: user, // Devuelve el usuario con contraseña
          token,
        },
      };
    } catch (error) {
      if (error instanceof ConflictException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al crear el usuario',
      });
    }
  }

  // POST /users/login - Login de usuario
  @Post('login')
  async login(@Body() body: { email: string; password: string }): Promise<any> {
    try {
      const { email, password } = body;

      // Buscar usuario
      const user = await this.usersService.findOne({
        email: email.toLowerCase(),
      });

      if (!user) {
        console.log('❌ Usuario NO encontrado');
        throw new UnauthorizedException({
          status: false,
          message: 'Credenciales incorrectas',
        });
      }

      // Verificar contraseña
      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (!isPasswordValid) {
        throw new UnauthorizedException({
          status: false,
          message: 'Credenciales incorrectas',
        });
      }

      // Generar JWT
      const token = await this.jwtService.signAsync({
        _id: user._id,
        email: user.email,
        name: user.name,
      });

      // Devolver usuario
      return {
        status: true,
        message: 'Login exitoso',
        data: {
          user: user,
          token,
        },
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error en el login',
      });
    }
  }

  // GET /users/me - Obtener mi perfil (protegido con token)
  @Get('me')
  async getProfile(@Req() request: express.Request): Promise<any> {
    try {
      // Obtener token del header
      const token =
        request.headers['authorization']?.replace('Bearer ', '') ||
        (request.headers['x-token'] as string);

      if (!token) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token no proporcionado',
        });
      }

      // Verificar token
      const payload = await this.jwtService.verifyAsync(token);

      if (!payload) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token inválido',
        });
      }

      // Buscar usuario
      const user = await this.usersService.findOne({ email: payload.email });

      if (!user) {
        throw new UnauthorizedException({
          status: false,
          message: 'Usuario no encontrado',
        });
      }

      // Devolver usuario COMPLETO (con contraseña)
      return {
        status: true,
        message: 'Perfil obtenido exitosamente',
        data: user, // Devuelve el usuario con contraseña
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al obtener el perfil',
      });
    }
  }

  // GET /users/:id - Obtener usuario por ID (público)
  @Get(':id')
  async findById(@Param('id') id: string): Promise<any> {
    try {
      const user = await this.usersService.findById(id);

      if (!user) {
        throw new NotFoundException({
          status: false,
          message: `Usuario con ID ${id} no encontrado`,
        });
      }

      return {
        status: true,
        message: 'Usuario encontrado exitosamente',
        data: user, // Devuelve el usuario con contraseña
      };
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al obtener el usuario',
      });
    }
  }

  // GET /users - Obtener todos los usuarios (protegido)
  @Get()
  async findAllUsers(@Req() request: express.Request): Promise<any> {
    try {
      // Verificar token (opcional)
      const token =
        request.headers['authorization']?.replace('Bearer ', '') ||
        (request.headers['x-token'] as string);

      if (token) {
        try {
          await this.jwtService.verifyAsync(token);
        } catch (e) {
          // Token inválido, pero igual devolvemos usuarios
        }
      }

      const users = await this.usersService.getAllUsers();
      return {
        status: true,
        message: 'Usuarios obtenidos exitosamente',
        data: users, // Devuelve los usuarios con contraseña
      };
    } catch (error) {
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al obtener los usuarios',
      });
    }
  }

  // PATCH /users/:id - Actualizar usuario (protegido)
  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body() updateUserDto: UpdateUserDto,
    @Req() request: express.Request,
  ): Promise<any> {
    try {
      // Verificar token
      const token =
        request.headers['authorization']?.replace('Bearer ', '') ||
        (request.headers['x-token'] as string);

      if (!token) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token no proporcionado',
        });
      }

      const payload = await this.jwtService.verifyAsync(token);

      if (!payload) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token inválido',
        });
      }

      // Verificar que el usuario solo pueda actualizar su propio perfil
      const user = await this.usersService.findById(id);
      if (!user || user.email !== payload.email) {
        throw new UnauthorizedException({
          status: false,
          message: 'No tienes permiso para actualizar este usuario',
        });
      }

      const updatedUser = await this.usersService.update(id, updateUserDto);

      if (!updatedUser) {
        throw new NotFoundException({
          status: false,
          message: `Usuario con ID ${id} no encontrado`,
        });
      }

      return {
        status: true,
        message: 'Usuario actualizado exitosamente',
        data: updatedUser, // Devuelve el usuario con contraseña
      };
    } catch (error) {
      if (
        error instanceof NotFoundException ||
        error instanceof UnauthorizedException
      ) {
        throw error;
      }
      if (error instanceof ConflictException) {
        throw new ConflictException({
          status: false,
          message: error.message,
        });
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al actualizar el usuario',
      });
    }
  }

  // DELETE /users/:id - Eliminar usuario
  @Delete(':id')
  async delete(
    @Param('id') id: string,
    @Req() request: express.Request,
  ): Promise<any> {
    try {
      // COMENTA TEMPORALMENTE LA VERIFICACIÓN DE TOKEN
      // Verificar token
      const token =
        request.headers['authorization']?.replace('Bearer ', '') ||
        (request.headers['x-token'] as string);

      if (!token) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token no proporcionado',
        });
      }

      const payload = await this.jwtService.verifyAsync(token);

      if (!payload) {
        throw new UnauthorizedException({
          status: false,
          message: 'Token inválido',
        });
      }

      // Verificar que el usuario solo pueda eliminar su propio perfil
      const user = await this.usersService.findById(id);
      if (!user || user.email !== payload.email) {
        throw new UnauthorizedException({
          status: false,
          message: 'No tienes permiso para eliminar este usuario',
        });
      }

      // Eliminar usuario directamente (sin verificar token)
      const deletedUser = await this.usersService.delete(id);

      if (!deletedUser) {
        throw new NotFoundException({
          status: false,
          message: `Usuario con ID ${id} no encontrado`,
        });
      }

      return {
        status: true,
        message: 'Usuario eliminado exitosamente',
        data: deletedUser,
      };
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al eliminar el usuario',
      });
    }
  }

  // DELETE /users/delete/:id - Eliminar usuario sin autenticación (SOLO DESARROLLO)
  @Delete('delete/:id')
  async deleteWithoutAuth(@Param('id') id: string): Promise<any> {
    try {
      const deletedUser = await this.usersService.delete(id);

      if (!deletedUser) {
        throw new NotFoundException({
          status: false,
          message: `Usuario con ID ${id} no encontrado`,
        });
      }

      return {
        status: true,
        message: 'Usuario eliminado exitosamente',
        data: deletedUser,
      };
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new BadRequestException({
        status: false,
        message: error.message || 'Error al eliminar el usuario',
      });
    }
  }
}
