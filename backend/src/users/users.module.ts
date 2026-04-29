import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserSchema } from './schemas/user.schema';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { JwtModule } from '@nestjs/jwt';
import { AuthGuard } from './guards/auth.guard';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { ImageCompressionService } from '../services/image-compression.service';
import { ProductSchema } from '../product/schemas/product.schema';
import { RoutineSchema } from '../routines/schemas/routine.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: 'Users',
        schema: UserSchema,
        collection: 'users',
      },
      { name: 'Product', schema: ProductSchema },
      { name: 'Routine', schema: RoutineSchema },
    ]),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret:
          configService.get<string>('JWT_SECRET') ||
          'mi_clave_secreta_temporal_para_desarrollo',
        signOptions: { expiresIn: '3h' },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [UsersController],
  providers: [
    UsersService,
    AuthGuard,
    CloudinaryService,
    ImageCompressionService,
  ],
  exports: [UsersService, AuthGuard, JwtModule, CloudinaryService],
})
export class UserModule {}
