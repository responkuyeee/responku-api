import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service.js';
import { dbService } from '../db/db.module.js';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { NotFoundException, BadRequestException } from '@nestjs/common';

describe('UsersService', () => {
    let service: UsersService;
    let mockDb: any;

    beforeEach(async () => {
        mockDb = {
            user: {
                findUnique: vi.fn(),
                update: vi.fn()
            },
            userProfile: {
                update: vi.fn(),
                create: vi.fn()
            }
        };

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                UsersService,
                {
                    provide: dbService,
                    useValue: mockDb
                }
            ]
        }).compile();

        service = module.get<UsersService>(UsersService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });

    describe('getUserProfile', () => {
        it('should throw NotFoundException if user is not found', async () => {
            mockDb.user.findUnique.mockResolvedValue(null);
            await expect(service.getUserProfile('non-existent')).rejects.toThrow(NotFoundException);
        });

        it('should return user with profile when user exists', async () => {
            const mockUser = {
                id: 'user-1',
                userProfile: { id: 'prof-1', userId: 'user-1', gender: 'MALE' },
                qualityScore: null
            };
            mockDb.user.findUnique.mockResolvedValue(mockUser);

            const result = await service.getUserProfile('user-1');
            expect(result).toEqual(mockUser);
        });
    });

    describe('verifyDomicile', () => {
        it('should throw NotFoundException if user is not found', async () => {
            mockDb.user.findUnique.mockResolvedValue(null);
            await expect(service.verifyDomicile('non-existent', { lat: -6.2, lng: 106.8 })).rejects.toThrow(NotFoundException);
        });

        it('should throw BadRequestException if user profile does not exist', async () => {
            mockDb.user.findUnique.mockResolvedValue({ id: 'user-1', userProfile: null });
            await expect(service.verifyDomicile('user-1', { lat: -6.2, lng: 106.8 })).rejects.toThrow(BadRequestException);
        });

        it('should update domicile coordinates and timestamp', async () => {
            const existingUser = {
                id: 'user-1',
                userProfile: { id: 'prof-1', domicileLatitude: null, domicileLongitude: null }
            };
            const updatedUser = {
                id: 'user-1',
                userProfile: { id: 'prof-1', domicileLatitude: '-6.2', domicileLongitude: '106.8', domicileVerifiedAt: new Date() }
            };

            mockDb.user.findUnique.mockResolvedValueOnce(existingUser).mockResolvedValueOnce(updatedUser);
            mockDb.userProfile.update.mockResolvedValue(updatedUser.userProfile);

            const result = await service.verifyDomicile('user-1', { lat: -6.2, lng: 106.8 });
            expect(mockDb.userProfile.update).toHaveBeenCalledWith({
                where: { userId: 'user-1' },
                data: {
                    domicileLatitude: '-6.2',
                    domicileLongitude: '106.8',
                    domicileVerifiedAt: expect.any(Date)
                }
            });
            expect(result).toEqual(updatedUser);
        });
    });
});
