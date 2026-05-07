import { registerAs } from '@nestjs/config';
import { getValidatedEnv } from './validation/env.validator';

export default registerAs('database', () => {
  const env = getValidatedEnv();
  return {
    url: env.DATABASE_URL,
  };
})