import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './infrastructure/prisma/prisma.module';
import { configurations } from './config';
import { validateEnv } from './config/validation/env.validator'; 

const NODE_ENV = process.env.NODE_ENV || 'development';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: configurations,
      validate: validateEnv,
      cache: true,
      envFilePath: [
        `.env.${NODE_ENV}.local`,                                                                                                                                                                                                           
        `.env.${NODE_ENV}`,
        '.env.local',                                                                                                                                                                                                                       
        '.env',                                   
      ],
    }),
    PrismaModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})

export class AppModule {}
