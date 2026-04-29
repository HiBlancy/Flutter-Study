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

export class RoutineProductDto {
  @IsString()
  @IsOptional()
  productId?: string;

  @IsNumber()
  @Min(0)
  @IsOptional()
  order?: number;
}

export class UpdateRoutineDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name?: string;

  @IsOptional()
  @IsIn(['morning', 'night'])
  time?: string;

  @IsOptional()
  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  daysOfWeek?: string[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RoutineProductDto)
  products?: RoutineProductDto[];
}
