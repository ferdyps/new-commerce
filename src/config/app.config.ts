import { registerAs } from '@nestjs/config';
import { getValidatedEnv } from './validation/env.validator';

export default registerAs('app', () => {
    const env = getValidatedEnv();
    return {
        nodeEnv: env.NODE_ENV,
        port: env.PORT,
    };
});