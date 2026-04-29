import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MinLength,
  IsDateString,
  IsStrongPassword,
} from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name?: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  @MinLength(8)
  @IsStrongPassword()
  password?: string;

  @IsOptional()
  @IsString()
  phone?: string | null;

  @IsOptional()
  @IsDateString()
  birthDate?: Date | null;

  @IsOptional()
  @IsString()
  profileImage?: string | null;
}
