import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { ProductModule } from './product/product.module';
import { RoutineModule } from './routines/routine.module';
import { ScheduleModule } from '@nestjs/schedule';

@Module({
  imports: [
    ConfigModule.forRoot(),
    MongooseModule.forRoot(process.env.URL as string),
    JwtModule.register({
      secret:
        process.env.JWT_SECRET || 'mi_clave_secreta_temporal_para_desarrollo',
      signOptions: { expiresIn: '3h' },
    }),
    ScheduleModule.forRoot(),
    UserModule,
    ProductModule,
    RoutineModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
