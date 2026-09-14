import { Module } from '@nestjs/common';
import { UploadersService } from './uploaders.service.js';
import { UploadersController } from './uploaders.controller.js';
import { AuthService } from '../auth/auth.service.js';

@Module({
    controllers: [UploadersController],
    providers: [UploadersService, AuthService],
    exports: [UploadersService]
})
export class UploadersModule {}
