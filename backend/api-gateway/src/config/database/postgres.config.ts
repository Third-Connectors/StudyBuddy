import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmOptionsFactory, TypeOrmModuleOptions } from '@nestjs/typeorm';

@Injectable()
export class TypeOrmConfigService implements TypeOrmOptionsFactory {
  constructor(private configService: ConfigService) {}

  createTypeOrmOptions(): TypeOrmModuleOptions {
    return {
      type: 'postgres',
      host: this.configService.get<string>('POSTGRES_HOST', 'localhost'),
      port: this.configService.get<number>('POSTGRES_PORT', 5432),
      username: this.configService.get<string>('POSTGRES_USER', 'studybuddy'),
      password: this.configService.get<string>('POSTGRES_PASSWORD'),
      database: this.configService.get<string>('POSTGRES_DB', 'studybuddy_users'),
      entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
      migrations: [__dirname + '/migrations/*{.ts,.js}'],
      synchronize: this.configService.get<string>('NODE_ENV') === 'development',
      logging: this.configService.get<string>('NODE_ENV') === 'development',
      ssl: {
        rejectUnauthorized: false,
      },
      extra: {
        max: 20,
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 10000,
      },
    };
  }
}

export const postgresDataSourceOptions = {
  inject: [ConfigService],
  useFactory: (configService: ConfigService) => {
    const databaseUrl = configService.get<string>('DATABASE_URL');
    
    if (databaseUrl) {
      return {
        type: 'postgres',
        url: databaseUrl,
        entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
        migrations: [__dirname + '/migrations/*{.ts,.js}'],
        synchronize: configService.get<string>('NODE_ENV') === 'development',
        logging: configService.get<string>('NODE_ENV') === 'development',
        ssl: {
          rejectUnauthorized: false,
        },
      };
    }

    return {
      type: 'postgres',
      host: configService.get<string>('POSTGRES_HOST', 'localhost'),
      port: configService.get<number>('POSTGRES_PORT', 5432),
      username: configService.get<string>('POSTGRES_USER', 'studybuddy'),
      password: configService.get<string>('POSTGRES_PASSWORD'),
      database: configService.get<string>('POSTGRES_DB', 'studybuddy_users'),
      entities: [__dirname + '/../../**/*.entity{.ts,.js}'],
      migrations: [__dirname + '/migrations/*{.ts,.js}'],
      synchronize: configService.get<string>('NODE_ENV') === 'development',
      logging: configService.get<string>('NODE_ENV') === 'development',
      ssl: {
        rejectUnauthorized: false,
      },
      extra: {
        connectTimeout: 10000,
      },
    };
  },
};
