import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  BadRequestException,
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
import { multerImageFilter } from '../common/multer.utils';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { LoginUserDto } from './dto/login-user.dto';

@ApiTags('Usuarios')
@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  // respuesta 200 / 201
  private successResponse(message: string, data: any = null) {
    return { status: true, message, data };
  }

  // registra -> crea usuario y devuelve token
  @ApiOperation({ summary: 'Registrar un nuevo usuario' })
  @ApiBody({ type: CreateUserDto })
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

  // inicia sesion -> comprueba credenciales si coinciden (email y contra) y devuelve un token
  @ApiOperation({ summary: 'Iniciar sesion y obtener token JWT' })
  @ApiBody({ type: LoginUserDto })
  @Post('login')
  async login(@Body() body: LoginUserDto) {
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

  // obtener informacion del usuario logeado
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Obtener perfil del usuario autenticado' })
  @UseGuards(AuthGuard)
  @Get('me')
  async getProfile(@Req() req) {
    return this.successResponse('Perfil obtenido', req.user);
  }

  // actualizar informacion del usuario
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Actualizar perfil del usuario autenticado' })
  @UseGuards(AuthGuard)
  @Patch('me')
  async updateProfile(@Body() updateUserDto: UpdateUserDto, @Req() req) {
    const updatedUser = await this.usersService.update(
      req.user._id,
      updateUserDto,
    );
    return this.successResponse('Perfil actualizado', updatedUser);
  }

  // sube foto de perfil, borrando la anterior y subiendola a Cloudinary
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Subir imagen de perfil' })
  @ApiConsumes('multipart/form-data')
  @UseGuards(AuthGuard)
  @Patch('me/upload-image')
  @UseInterceptors(
    FileInterceptor('profileImage', {
      limits: { fileSize: 10 * 1024 * 1024 },
      fileFilter: multerImageFilter(['image/jpeg', 'image/png', 'image/webp', 'image/heic']),
    }),
  )
  async uploadProfileImage(@UploadedFile() file: Express.Multer.File, @Req() req) {
    if (!file) {
      throw new BadRequestException('No se proporcionó ningún archivo');
    }

    const updatedUser = await this.usersService.updateProfileImage(
      req.user._id,
      file.buffer,
      file.mimetype
    );

    return this.successResponse('Imagen de perfil actualizada exitosamente', updatedUser);
  }

  // lista todos los usuarios
  @ApiOperation({ summary: 'Listar usuarios' })
  @Get()
  async findAllUsers() {
    const users = await this.usersService.getAllUsers();
    return this.successResponse('Usuarios obtenidos', users);
  }

  // elimina la cuenta del usuario
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Eliminar cuenta del usuario autenticado' })
  @UseGuards(AuthGuard)
  @Delete('me')
  async deleteMyAccount(@Req() req) {
    const userId = req.user._id;
    const deletedUser = await this.usersService.delete(userId);
    return this.successResponse('Cuenta eliminada exitosamente', deletedUser);
  }

  // elimina la foto de perfil
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Eliminar imagen de perfil del usuario autenticado' })
  @UseGuards(AuthGuard)
  @Delete('me/image')
  async deleteProfileImage(@Req() req) {
    const updatedUser = await this.usersService.deleteProfileImage(req.user._id);
    return this.successResponse('Imagen de perfil eliminada exitosamente', updatedUser);
  }
}