import { IsIn, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class MoveProductDto {
  @ApiProperty({
    example: 'used',
    enum: ['wishlist', 'have', 'used'],
    description: 'Lista de destino del producto',
  })
  @IsNotEmpty()
  @IsIn(['wishlist', 'have', 'used'])
  targetList: string;
}