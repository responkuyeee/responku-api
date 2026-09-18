import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller.js';
import { UsersService } from './users.service.js';
import { AuthService } from '../auth/auth.service.js';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '../utils/guard.js';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { type Request } from 'express';

describe('UsersController', () => {
    let controller: UsersController;
    let usersService: UsersService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            controllers: [UsersController],
            providers: [
                {
                    provide: UsersService,
                    useValue: {
                        updateUserProfile: vi.fn(),
                        verifyDomicile: vi.fn(),
                        getUserProfile: vi.fn()
                    }
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

        controller = module.get<UsersController>(UsersController);
        usersService = module.get<UsersService>(UsersService);
    });

    it('should be defined', () => {
        expect(controller).toBeDefined();
    });

    it('should verify domicile', async () => {
        const req = { withUser: { id: 'user-1' } } as unknown as Request;
        const dto = { lat: -6.2, lng: 106.8 };
        const mockResult = { id: 'user-1', userProfile: { domicileLatitude: '-6.2', domicileLongitude: '106.8' } } as any;
        vi.spyOn(usersService, 'verifyDomicile').mockResolvedValue(mockResult);

        const response = await controller.verifyDomicile(req, dto);
        expect(usersService.verifyDomicile).toHaveBeenCalledWith('user-1', dto);
        expect(response).toEqual({ data: mockResult, message: 'domicile-verify success' });
    });

    it('should get user profile', async () => {
        const req = { withUser: { id: 'user-1' } } as unknown as Request;
        const mockProfile = { id: 'profile-1', userId: 'user-1', gender: 'MALE' } as any;
        vi.spyOn(usersService, 'getUserProfile').mockResolvedValue(mockProfile);

        const response = await controller.getUserProfile(req);
        expect(usersService.getUserProfile).toHaveBeenCalledWith('user-1');
        expect(response).toEqual({ data: mockProfile, message: 'get-profile success' });
    });

    it('should update user profile', async () => {
        const req = { withUser: { id: 'user-1' } } as unknown as Request;
        const dto = { name: 'Updated Name', gender: 'MALE' as const };
        const mockResult = { id: 'user-1', name: 'Updated Name', userProfile: { gender: 'MALE' } } as any;
        vi.spyOn(usersService, 'updateUserProfile').mockResolvedValue(mockResult);

        const response = await controller.updateUserProfile(req, dto);
        expect(usersService.updateUserProfile).toHaveBeenCalledWith('user-1', dto);
        expect(response).toEqual({ data: mockResult, message: 'update-profile success' });
    });
});
