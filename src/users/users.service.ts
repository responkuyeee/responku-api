import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { type DbService, dbService } from '../db/db.module.js';
import { DomicileVerifyDto, UpdateUserProfileReqDto } from './dto/users.dto.js';

@Injectable()
export class UsersService {
    constructor(@Inject(dbService) private readonly db: DbService) {}

    async updateUserProfile(userId: string, dto: UpdateUserProfileReqDto) {
        const user = await this.db.user.findUnique({
            where: { id: userId },
            include: { userProfile: true }
        });

        if (!user) throw new NotFoundException('User not found');
        const { name, image, religionConsentAt, dataShareConsentAt, ...profileData } = dto;

        if (name !== undefined || image !== undefined) {
            await this.db.user.update({
                where: { id: userId },
                data: {
                    ...(name !== undefined && { name }),
                    ...(image !== undefined && { image })
                }
            });
        }

        const parsedReligionConsentAt = religionConsentAt ? new Date(religionConsentAt) : undefined;
        const parsedDataShareConsentAt = dataShareConsentAt ? new Date(dataShareConsentAt) : undefined;

        const updateData = {
            ...profileData,
            ...(parsedReligionConsentAt && { religionConsentAt: parsedReligionConsentAt }),
            ...(parsedDataShareConsentAt && { dataShareConsentAt: parsedDataShareConsentAt })
        };

        if (user.userProfile) {
            await this.db.userProfile.update({
                where: { userId },
                data: updateData
            });
        } else {
            if (!updateData.gender) {
                throw new BadRequestException('Gender is required when creating a profile for the first time');
            }
            await this.db.userProfile.create({
                data: {
                    userId,
                    gender: updateData.gender,
                    ...updateData
                }
            });
        }

        // Return updated user with profile
        const updatedUser = await this.db.user.findUnique({
            where: { id: userId },
            include: { userProfile: true }
        });

        return updatedUser;
    }

    async verifyDomicile(userId: string, dto: DomicileVerifyDto) {
        const user = await this.db.user.findUnique({
            where: { id: userId },
            include: { userProfile: true }
        });

        if (!user) throw new NotFoundException('User not found');
        if (!user.userProfile) throw new BadRequestException('User profile not found. Please complete profile first');

        await this.db.userProfile.update({
            where: { userId },
            data: {
                domicileLatitude: dto.lat.toString(),
                domicileLongitude: dto.lng.toString(),
                domicileVerifiedAt: new Date()
            }
        });

        return this.db.user.findUnique({
            where: { id: userId },
            include: { userProfile: true }
        });
    }

    async getUserProfile(userId: string) {
        const user = await this.db.user.findUnique({
            where: { id: userId },
            include: { userProfile: true, qualityScore: true }
        });

        if (!user) throw new NotFoundException('User not found');
        return user;
    }
}
