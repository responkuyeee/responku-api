import { Test, TestingModule } from '@nestjs/testing';
import { Reflector } from '@nestjs/core';
import { UploadersController } from './uploaders.controller.js';
import { UploadersService } from './uploaders.service.js';
import { AuthService } from '../auth/auth.service.js';
import { AuthGuard } from '../utils/guard.js';
import { vi, describe, it, expect, beforeEach } from 'vitest';

describe('UploadersController', () => {
    let controller: UploadersController;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            controllers: [UploadersController],
            providers: [
                {
                    provide: UploadersService,
                    useValue: {}
                },
                {
                    provide: AuthService,
                    useValue: {}
                },
                {
                    provide: Reflector,
                    useValue: {}
                }
            ]
        })
            .overrideGuard(AuthGuard)
            .useValue({ canActivate: vi.fn(() => true) })
            .compile();

        controller = module.get<UploadersController>(UploadersController);
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });
});
