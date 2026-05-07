import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsNotEmpty, IsString, Matches, Max, Min } from 'class-validator';

export enum NodeEnv {
    Development = 'development',
    Production = 'production',
    Test = 'test',
    Staging = 'staging',
}

export class EnvironmentVariables {
    @IsEnum(NodeEnv)
    NODE_ENV: NodeEnv;

    @IsString()
    @IsNotEmpty()
    DATABASE_URL!: string;

    @IsInt()
    @Min(1)
    @Max(65535)
    @Type(() => Number)
    PORT: number = 3000;

    @IsString()
    @IsNotEmpty()
    API_PREFIX: string = 'api';

    @IsString()
    @Matches(/^\d+$/, { message: 'API_DEFAULT_VERSION must be a numeric string (e.g. "1")' })
    API_DEFAULT_VERSION: string = '1';
}

