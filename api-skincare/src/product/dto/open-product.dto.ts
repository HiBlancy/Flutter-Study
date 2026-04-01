import { IsOptional, IsString } from 'class-validator';

export class OpenProductDto {
  @IsOptional()
  @IsString()
  periodAfterOpening?: string;  // Si no está en el producto, se puede especificar aquí
}