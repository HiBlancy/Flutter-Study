import { IsIn, IsNotEmpty } from 'class-validator';

export class MoveProductDto {
  @IsNotEmpty()
  @IsIn(['wishlist', 'have', 'used'])
  targetList: string;
}