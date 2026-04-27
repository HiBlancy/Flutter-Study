// update-product.dto.ts - ACTUALIZADO para aceptar nulls
import {
  IsOptional,
  IsString,
  IsNotEmpty,
  IsUrl,
  IsArray,
  IsNumber,
  Min,
  Max,
  IsIn,
  IsBoolean,
  IsDate,
  Matches,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';

export class UpdateProductDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  name?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  brand?: string | null; // ✅ Permitir null

  @IsOptional()
  @IsUrl()
  imageUrl?: string | null; // ✅ Permitir null

  @IsOptional()
  @IsString()
  barcode?: string | null; // ✅ Permitir null

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  categories?: string[] | null; // ✅ Permitir null

  @IsOptional()
  @IsString()
  notes?: string | null; // ✅ Permitir null (para limpiar)

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(5)
  rating?: number | null; // ✅ Permitir null (para limpiar)

  @IsOptional()
  @IsIn(['wishlist', 'have', 'used'])
  listType?: string;

  @IsOptional()
  @Transform(({ value }) => {
    if (value === null) return null;
    // Permite limpiar la fecha enviando string vacío desde frontend.
    if (value === '') return null;
    if (value === undefined) return undefined;
    const date = new Date(value);
    // Normalizar a UTC medianoche
    return new Date(
      Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()),
    );
  })
  expirationDate?: Date | string | null; // ✅ Permitir null (para limpiar)

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
  @Type(() => Date)
  @IsDate()
  openedDate?: Date | string | null; // ✅ Permitir null (para limpiar)

  @IsOptional()
  @IsBoolean()
  isOpened?: boolean | null; // ✅ Permitir null
}