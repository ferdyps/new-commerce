import { NestFactory } from '@nestjs/core';
import { RequestMethod, VersioningType } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { AppModule } from '@/app.module';
import { apiConfig, appConfig } from '@/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const appCfg = app.get<ConfigType<typeof appConfig>>(appConfig.KEY);
  const apiCfg = app.get<ConfigType<typeof apiConfig>>(apiConfig.KEY);

  app.setGlobalPrefix(apiCfg.prefix, {
    exclude: apiCfg.excludePaths.map((path) => ({
      path,
      method: RequestMethod.ALL,
    })),
  });

  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: apiCfg.defaultVersion,
  });

  app.enableShutdownHooks();

  await app.listen(appCfg.port);
}
bootstrap();
