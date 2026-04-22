// src/users/users.controller.ts
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
  UseGuards,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtService } from '@nestjs/jwt';
import { AuthGuard } from './guards/auth.guard';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { ImageCompressionService } from '../services/image-compression.service';

function createMulterImageFilter(allowedMimes: string[]) {
  return (req: any, file: Express.Multer.File, cb: any) => {
    if (!allowedMimes.includes(file.mimetype)) {
      cb(
        new BadRequestException(
          `Tipo de archivo no permitido. Permitidos: ${allowedMimes.join(', ')}`,
        ),
        false,
      );
    } else {
      cb(null, true);
    }
  };
}

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly cloudinaryService: CloudinaryService,
    private readonly imageCompressionService: ImageCompressionService, 
  ) {}

  private successResponse(message: string, data: any = null) {
    return { status: true, message, data };
  }

  // Register: crea usuario y devuelve token.
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    try {
      const user = await this.usersService.create({
        ...createUserDto,
        email: createUserDto.email.toLowerCase(),
      });

      const token = await this.jwtService.signAsync({
        _id: user._id,
        email: user.email,
        name: user.name,
      });

      return this.successResponse('Usuario registrado exitosamente', {
        user,
        token,
      });
    } catch (error) {
      if (error instanceof ConflictException) throw error;
      throw new BadRequestException(error.message || 'Error al crear usuario');
    }
  }

  // Login: valida credenciales y devuelve token.
  @Post('login')
  async login(@Body() body: { email: string; password: string }) {
    try {
      const user = await this.usersService.findOne({
        email: body.email.toLowerCase(),
      });
      if (!user || !(await user.comparePassword(body.password))) {
        throw new UnauthorizedException('Credenciales incorrectas');
      }

      const token = await this.jwtService.signAsync({
        _id: user._id,
        email: user.email,
        name: user.name,
      });

      return this.successResponse('Login exitoso', { user, token });
    } catch (error) {
      if (error instanceof UnauthorizedException) throw error;
      throw new BadRequestException(error.message || 'Error en login');
    }
  }

  @UseGuards(AuthGuard)
  @Get('me')
  async getProfile(@Req() req) {
    // Devuelve el usuario del token (set por el guard).
    return this.successResponse('Perfil obtenido', req.user);
  }

  @UseGuards(AuthGuard)
  @Patch('me')
  async updateProfile(@Body() updateUserDto: UpdateUserDto, @Req() req) {
    // Actualiza perfil del usuario autenticado.
    const updatedUser = await this.usersService.update(
      req.user._id,
      updateUserDto,
    );
    return this.successResponse('Perfil actualizado', updatedUser);
  }

  // Sube imagen de perfil: comprime, sube a Cloudinary, borra la anterior y guarda la URL.
  @UseGuards(AuthGuard)
  @Patch('me/upload-image')
  @UseInterceptors(
    FileInterceptor('profileImage', {
      limits: {
        fileSize: 10 * 1024 * 1024, // 10MB (fotos de cámara)
      },
      fileFilter: createMulterImageFilter([
        'image/jpeg',
        'image/png',
        'image/webp',
        'image/heic',
      ]),
    }),
  )
  async uploadProfileImage(
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ) {
    try {
      // Validar archivo.
      if (!file) {
        throw new BadRequestException('No se proporcionó ningún archivo');
      }

      // Comprimir antes de subir (menos peso / más rápido).
      const compressedBuffer = await this.imageCompressionService.compressProfileImage(
        file.buffer,
        file.mimetype,
      );

      console.log(`✅ Imagen comprimida exitosamente`);

      // Subir a Cloudinary.
      const imageUrl = await this.cloudinaryService.uploadImage(
        compressedBuffer,
        `${req.user._id}_profile_${Date.now()}`,
        'user-profiles',
      );

      // Eliminar imagen anterior (si existe).
      const currentUser = await this.usersService.findById(req.user._id);
      if (currentUser?.profileImage) {
        const publicId = this.cloudinaryService.extractPublicIdFromUrl(
          currentUser.profileImage,
        );
        if (publicId) {
          await this.cloudinaryService.deleteImage(publicId);
          console.log(`🗑️ Imagen anterior eliminada: ${publicId}`);
        }
      }

      // Guardar URL en el usuario.
      const updateDto: UpdateUserDto = {
        profileImage: imageUrl,
      };

      const updatedUser = await this.usersService.update(
        req.user._id,
        updateDto,
      );

      console.log(`✅ Imagen de perfil actualizada para usuario ${req.user._id}`);
      console.log(`   - URL: ${imageUrl}`);

      return this.successResponse(
        'Imagen de perfil actualizada exitosamente',
        updatedUser,
      );
    } catch (error) {
      console.error('❌ Error al subir imagen:', error);
      if (error instanceof BadRequestException) throw error;
      throw new BadRequestException(
        error.message || 'Error al subir la imagen',
      );
    }
  }

  @Get()
  async findAllUsers() {
    // Lista usuarios (sin password).
    const users = await this.usersService.getAllUsers();
    return this.successResponse('Usuarios obtenidos', users);
  }

  @UseGuards(AuthGuard)
  @Delete('me')
  async deleteMyAccount(@Req() req) {
    // Elimina la cuenta del usuario autenticado.
    const userId = req.user._id;
    const deletedUser = await this.usersService.delete(userId);
    return this.successResponse('Cuenta eliminada exitosamente', deletedUser);
  }

  @UseGuards(AuthGuard)
  @Delete('me/image')
  async deleteProfileImage(@Req() req) {
    try {
      const userId = req.user._id;
      const user = await this.usersService.findById(userId);

      if (!user) {
        throw new NotFoundException('Usuario no encontrado');
      }

      if (!user.profileImage) {
        throw new BadRequestException('No hay imagen de perfil para eliminar');
      }

      // Borrar imagen en Cloudinary.
      const publicId = this.cloudinaryService.extractPublicIdFromUrl(user.profileImage);
      if (publicId) {
        await this.cloudinaryService.deleteImage(publicId);
        console.log(`🗑️ Imagen de perfil eliminada de Cloudinary: ${publicId}`);
      }

      // Quitar URL del usuario.
      const updatedUser = await this.usersService.update(userId, { profileImage: null });

      return this.successResponse('Imagen de perfil eliminada exitosamente', updatedUser);
    } catch (error) {
      console.error('❌ Error al eliminar imagen de perfil:', error);
      if (error instanceof BadRequestException) throw error;
      if (error instanceof NotFoundException) throw error;
      throw new BadRequestException(error.message || 'Error al eliminar la imagen');
    }
  }
}