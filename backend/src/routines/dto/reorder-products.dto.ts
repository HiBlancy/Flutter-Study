import {
  IsArray,
  ValidateNested,
  IsString,
  IsNumber,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';

export class ReorderProductDto {
  @IsString()
  productId: string;

  @IsNumber()
  @Min(0)
  order: number;
}

export class ReorderProductsDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ReorderProductDto)
  products: ReorderProductDto[];
}
