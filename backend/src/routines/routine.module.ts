import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { RoutineController } from './routine.controller';
import { RoutineService } from './routine.service';
import { RoutineSchema } from './schemas/routine.schema';
import { UserModule } from '../users/users.module';
import { ProductSchema } from '../product/schemas/product.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: 'Routine',
        schema: RoutineSchema,
        collection: 'routine',
      },
      {
        name: 'Product',
        schema: ProductSchema,
        collection: 'products' },
    ]),
    UserModule,
  ],
  controllers: [RoutineController],
  providers: [RoutineService],
  exports: [RoutineService],
})
export class RoutineModule {}
