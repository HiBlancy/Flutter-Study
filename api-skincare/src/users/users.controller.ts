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
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtService } from '@nestjs/jwt';
import { AuthGuard } from './guards/auth.guard';

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  // Helper para respuestas consistentes
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
    const updatedUser = await this.usersService.update(req.user._id, updateUserDto);
    return this.successResponse('Perfil actualizado', updatedUser);
  }

  // @Get(':id')
  // async findById(@Param('id') id: string) {
  //   const user = await this.usersService.findById(id);
  //   if (!user) throw new NotFoundException(`Usuario ${id} no encontrado`);
  //   return this.successResponse('Usuario encontrado', user);
  // }

  @Get()
  async findAllUsers() {
    const users = await this.usersService.getAllUsers();
    return this.successResponse('Usuarios obtenidos', users);
  }

  // @UseGuards(AuthGuard)
  // @Patch(':id')
  // async update(
  //   @Param('id') id: string,
  //   @Body() updateUserDto: UpdateUserDto,
  //   @Req() req,
  // ) {
  //   if (req.user._id !== id) {
  //     throw new UnauthorizedException('No puedes actualizar otro usuario');
  //   }

  //   const updatedUser = await this.usersService.update(id, updateUserDto);

  //   return this.successResponse('Usuario actualizado', updatedUser);
  // }

  @UseGuards(AuthGuard)
  @Delete(':id')
  async delete(@Param('id') id: string, @Req() req) {
    if (req.user._id !== id) {
      throw new UnauthorizedException('No puedes eliminar otro usuario');
    }

    const deletedUser = await this.usersService.delete(id);

    return this.successResponse('Usuario eliminado', deletedUser);
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
}
