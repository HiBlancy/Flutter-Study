import { IsIn, IsNotEmpty } from 'class-validator';

export class MoveProductDto {
  @IsNotEmpty()
  @IsIn(['wishlist', 'favorites', 'have', 'used', 'deleted'])
  targetList: string;
}