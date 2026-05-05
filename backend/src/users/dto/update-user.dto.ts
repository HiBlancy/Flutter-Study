import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MinLength,
  IsDateString,
  IsStrongPassword,
} from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'Ieva', description: 'Nombre del usuario' })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name?: string;

  @ApiPropertyOptional({ example: 'user@mail.com', description: 'Email del usuario' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: 'Abc12345!', description: 'Contrasena segura' })
  @IsOptional()
  @IsString()
  @MinLength(8)
  @IsStrongPassword()
  password?: string;

  @ApiPropertyOptional({ example: '+34123456789', description: 'Telefono de contacto' })
  @IsOptional()
  @IsString()
  phone?: string | null;

  @ApiPropertyOptional({ example: '2000-01-01', description: 'Fecha de nacimiento (YYYY-MM-DD)' })
  @IsOptional()
  @IsDateString()
  birthDate?: Date | null;

  @ApiPropertyOptional({ example: 'https://res.cloudinary.com/.../image.jpg', description: 'URL de la imagen de perfil' })
  @IsOptional()
  @IsString()
  profileImage?: string | null;
}
