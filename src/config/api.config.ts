import { registerAs } from '@nestjs/config';
import { getValidatedEnv } from './validation/env.validator';

export default registerAs('api', () => {
    const env = getValidatedEnv();
    return {
        prefix: env.API_PREFIX,
        defaultVersion: env.API_DEFAULT_VERSION,
        excludePaths: ['health', 'docs'] as const,
    };
});
