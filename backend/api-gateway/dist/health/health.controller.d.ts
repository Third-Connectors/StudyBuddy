import { HealthCheckService, HttpHealthIndicator, TypeOrmHealthIndicator, MongooseHealthIndicator, HealthCheckResult } from '@nestjs/terminus';
export declare class HealthController {
    private health;
    private http;
    private db;
    private mongoose;
    constructor(health: HealthCheckService, http: HttpHealthIndicator, db: TypeOrmHealthIndicator, mongoose: MongooseHealthIndicator);
    check(): Promise<HealthCheckResult>;
}
