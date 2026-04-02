import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UserController } from './user.controller';
import { UserService } from './user.service';
import { User } from './entities/user.entity';
import { UserProfile } from './entities/user-profile.entity';
import { UserStat } from './entities/user-stat.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserProfile, UserStat])],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
