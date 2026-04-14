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
    return this.successResponse('Perfil obtenido', req.user);
  }

  @UseGuards(AuthGuard)
  @Patch('me')
  async updateProfile(@Body() updateUserDto: UpdateUserDto, @Req() req) {
    const updatedUser = await this.usersService.update(
      req.user._id,
      updateUserDto,
    );
    return this.successResponse('Perfil actualizado', updatedUser);
  }

  /**
   * 🆕 ENDPOINT PARA SUBIR IMAGEN DE PERFIL CON COMPRESIÓN
   * POST /users/me/upload-image
   */
  @UseGuards(AuthGuard)
  @Patch('me/upload-image')
  @UseInterceptors(
    FileInterceptor('profileImage', {
      limits: {
        fileSize: 10 * 1024 * 1024, // Aumentamos a 10MB para permitir fotos de cámara
      },
      fileFilter: (req: any, file: Express.Multer.File, cb: any) => {
        const allowedMimes = ['image/jpeg', 'image/png', 'image/webp', 'image/heic'];
        
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
      },
    }),
  )
  async uploadProfileImage(
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ) {
    try {
      // Validar que hay archivo
      if (!file) {
        throw new BadRequestException('No se proporcionó ningún archivo');
      }

      // ✅ COMPRIMIR LA IMAGEN
      const compressedBuffer = await this.imageCompressionService.compressProfileImage(
        file.buffer,
        file.mimetype,
      );

      console.log(`✅ Imagen comprimida exitosamente`);

      // Subir la imagen comprimida a Cloudinary
      const imageUrl = await this.cloudinaryService.uploadImage(
        compressedBuffer,
        `${req.user._id}_profile_${Date.now()}`,
        'user-profiles',
      );

      // Eliminar imagen anterior si existe
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

      // Actualizar usuario con la nueva URL
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
    const users = await this.usersService.getAllUsers();
    return this.successResponse('Usuarios obtenidos', users);
  }

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

      // Extraer el publicId de la URL de Cloudinary
      const publicId = this.cloudinaryService.extractPublicIdFromUrl(user.profileImage);
      if (publicId) {
        await this.cloudinaryService.deleteImage(publicId);
        console.log(`🗑️ Imagen de perfil eliminada de Cloudinary: ${publicId}`);
      }

      // Actualizar el usuario, poniendo profileImage como null
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