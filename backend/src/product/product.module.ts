import { Module } from '@nestjs/common';
import { ProductController } from './product.controller';
import { ProductService } from './product.service';
import { MongooseModule } from '@nestjs/mongoose';
import { ProductSchema } from './schemas/product.schema';
import { UserModule } from 'src/users/users.module';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { ImageCompressionService } from '../services/image-compression.service';
import { CleanupService } from '../monthly-stats/services/cleanup.service';
import { MonthlyStatsSchema } from '../monthly-stats/schemas/monthly-stats.schema';
import { RoutineSchema } from 'src/routines/schemas/routine.schema';
@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: 'Product',
        schema: ProductSchema,
        collection: 'products',
      },
      { 
        name: 'Routine', 
        schema: RoutineSchema,
        collection: 'routines'
      }, 
      {
        name: 'MonthlyStats',
        schema: MonthlyStatsSchema,
        collection: 'monthly_stats',
      },
    ]),
    UserModule
  ],
  controllers: [ProductController],
  providers: [
    ProductService,
    CloudinaryService,
    ImageCompressionService,
    CleanupService,
  ],
  exports: [ProductService, MongooseModule],
})
export class ProductModule {}
