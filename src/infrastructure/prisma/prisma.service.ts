import { Inject, Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { PrismaPg } from '@prisma/adapter-pg';                                                                                                                                                                                              
import { PrismaClient } from '@prisma/client';                                                                                                                                                                                              
import appConfig from "@/config/app.config"
import databaseConfig  from '@/config/database.config';
import { NodeEnv } from '@/config/validation/env.schema';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(
    @Inject(databaseConfig.KEY) private readonly dbCfg: ConfigType<typeof databaseConfig>,
    @Inject(appConfig.KEY) private readonly appCfg: ConfigType<typeof appConfig>,
  ) {
    const adapter = new PrismaPg({ connectionString: dbCfg.url });
    super({
      adapter: adapter,
      log: appCfg.nodeEnv === NodeEnv.Development
        ? ['query', 'error', 'warn']
        : ['error'],
    });
  }

  async onModuleInit() {                          
    await this.$connect();
  }
                                                                                                                                                                                                                                              
  async onModuleDestroy() {
    await this.$disconnect();                                                                                                                                                                                                               
  } 
}
