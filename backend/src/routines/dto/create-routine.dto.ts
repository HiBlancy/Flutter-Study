import {
  IsString,
  IsNotEmpty,
  IsIn,
  IsArray,
  ArrayMinSize,
  ValidateNested,
  IsOptional,
  IsNumber,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RoutineProductDto {
  @ApiProperty({ example: '6817abc1234567890def1234', description: 'ID del producto' })
  @IsString()
  @IsNotEmpty()
  productId: string;

  @ApiProperty({ example: 0, description: 'Posicion del producto en la rutina' })
  @IsNumber()
  @Min(0)
  order: number;
}

export class CreateRoutineDto {
  @ApiProperty({ example: 'Rutina de manana', description: 'Nombre de la rutina' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: 'morning', enum: ['morning', 'night'], description: 'Momento del dia de la rutina' })
  @IsIn(['morning', 'night'])
  @IsNotEmpty()
  time: string;

  @ApiProperty({ example: ['monday', 'wednesday', 'friday'], description: 'Dias de la semana' })
  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  daysOfWeek: string[];

  @ApiPropertyOptional({
    example: ['6817abc1234567890def1234'],
    description: 'IDs de productos asociados a la rutina',
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  products?: string[]; // solo IDs, sin orden
}
