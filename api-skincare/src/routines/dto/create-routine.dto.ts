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

export class RoutineProductDto {
  @IsString()
  @IsNotEmpty()
  productId: string;

  @IsNumber()
  @Min(0)
  order: number;
}

export class CreateRoutineDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsIn(['morning', 'night'])
  @IsNotEmpty()
  time: string;

  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  daysOfWeek: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  products?: string[]; // solo IDs, sin orden
}
