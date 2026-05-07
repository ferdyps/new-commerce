import { plainToInstance } from 'class-transformer';
import { validateSync } from 'class-validator';                                                                                                                                                                                             
import { EnvironmentVariables } from './env.schema';

let validatedEnv: EnvironmentVariables | null = null;


export function validateEnv ( raw: Record<string, unknown> ) : EnvironmentVariables {
    const config = plainToInstance(EnvironmentVariables, raw, {
        enableImplicitConversion: true,
    });

    const errors = validateSync(config, { skipMissingProperties: false });

    if (errors.length > 0) {
        const errorMessages = errors
            .map((e) => `- ${e.property}: ${Object.values(e.constraints ?? {}).join(', ')}`)
            .join('\n');

        throw new Error(`Environment variables validation failed:\n${errorMessages}`);
    }

    validatedEnv = config;
    return config;  
}

export function getValidatedEnv(): EnvironmentVariables {
    if (!validatedEnv) {
        throw new Error('Environment variables have not been validated yet. Please call validateEnv() first.');
    }
    
    return validatedEnv;
}