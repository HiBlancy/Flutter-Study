import { 
  IsString, 
  IsNotEmpty, 
  IsOptional, 
  IsUrl, 
  IsArray,
  IsNumber,
  Min,
  Max,
  IsIn 
} from 'class-validator';

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
  @IsIn(['wishlist', 'favorites', 'have', 'used', 'deleted'])
  listType?: string;

  @IsOptional()
  expirationDate?: Date | string;

  @IsOptional()
  @IsString()
  periodAfterOpening?: string; //"12M", "6M", "24M"
}