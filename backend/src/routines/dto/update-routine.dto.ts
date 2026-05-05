import {
  IsString,
  IsOptional,
  IsIn,
  IsArray,
  ArrayMinSize,
  ValidateNested,
  IsNumber,
  Min,
  IsNotEmpty,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class RoutineProductDto {
  @ApiPropertyOptional({ example: '6817abc1234567890def1234', description: 'ID del producto' })
  @IsString()
  @IsOptional()
  productId?: string;

  @ApiPropertyOptional({ example: 0, description: 'Posicion del producto en la rutina' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  order?: number;
}

export class UpdateRoutineDto {
  @ApiPropertyOptional({ example: 'Rutina de noche', description: 'Nombre de la rutina' })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name?: string;

  @ApiPropertyOptional({ example: 'night', enum: ['morning', 'night'], description: 'Momento del dia de la rutina' })
  @IsOptional()
  @IsIn(['morning', 'night'])
  time?: string;

  @ApiPropertyOptional({ example: ['monday', 'wednesday'], description: 'Dias de la semana' })
  @IsOptional()
  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  daysOfWeek?: string[];

  @ApiPropertyOptional({
    type: [RoutineProductDto],
    description: 'Listado de productos de la rutina con su orden',
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RoutineProductDto)
  products?: RoutineProductDto[];
}
