import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsUrl,
  IsArray,
  IsNumber,
  Min,
  Max,
  IsIn,
  IsBoolean,
  Matches,
} from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateProductDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  brand: string;

  @IsOptional()
  @IsUrl()
  imageUrl?: string;

  @IsOptional()
  @IsString()
  barcode?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  categories?: string[];

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(5)
  rating?: number;

  @IsOptional()
  @IsIn(['wishlist', 'have', 'used'])
  listType?: string;

  @IsOptional()
  @Transform(({ value }) => {
    if (!value) return undefined;
    const date = new Date(value);
    return new Date(
      Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()),
    );
  })
  expirationDate?: Date | string;

  @IsOptional()
  @Transform(({ value }) => {
    // Si no hay valor, retornamos undefined
    if (value === null || value === undefined) return undefined;

    // Convertir a número (si es string numérico o número)
    const num = typeof value === 'number' ? value : parseInt(value, 10);

    // Si no es un número válido, retornamos el valor original (fallará en @Matches)
    if (isNaN(num)) return value;

    // Añadimos la 'M' automáticamente
    return `${num}M`;
  })
  @IsString()
  @Matches(/^\d+M$/, {
    message: 'El período debe ser un número positivo seguido de M (ej: 12M)',
  })
  periodAfterOpening?: string;

  @IsOptional()
  @IsBoolean()
  isOpened?: boolean;
}