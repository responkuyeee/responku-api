import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsEnum, IsOptional, IsString } from 'class-validator';
import { GenderType } from '../../generated/prisma/enums.js';

export class UpdateUserProfileReqDto {
    @ApiPropertyOptional({ example: 'John Doe', description: 'User full name' })
    @IsOptional()
    @IsString()
    name?: string;

    @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg', description: 'User profile image URL' })
    @IsOptional()
    @IsString()
    image?: string;

    @ApiPropertyOptional({ example: 'MALE', enum: Object.values(GenderType), description: 'User gender' })
    @IsOptional()
    @IsEnum(GenderType, { message: 'Invalid gender type' })
    gender?: GenderType;

    @ApiPropertyOptional({ example: 'Islam', description: 'User religion' })
    @IsOptional()
    @IsString()
    religion?: string;

    @ApiPropertyOptional({ example: 'DKI Jakarta', description: 'User domicile province' })
    @IsOptional()
    @IsString()
    domicileProvince?: string;

    @ApiPropertyOptional({ example: 'Jakarta Selatan', description: 'User domicile city' })
    @IsOptional()
    @IsString()
    domicileCity?: string;

    @ApiPropertyOptional({ example: '-6.2088', description: 'User domicile latitude' })
    @IsOptional()
    @IsString()
    domicileLatitude?: string;

    @ApiPropertyOptional({ example: '106.8456', description: 'User domicile longitude' })
    @IsOptional()
    @IsString()
    domicileLongitude?: string;

    @ApiPropertyOptional({ example: 'Bachelor Degree', description: 'User education' })
    @IsOptional()
    @IsString()
    education?: string;

    @ApiPropertyOptional({ example: 'Software Engineer', description: 'User occupation' })
    @IsOptional()
    @IsString()
    occupation?: string;

    @ApiPropertyOptional({ description: 'Consent date for religion data sharing' })
    @IsOptional()
    @IsDateString()
    religionConsentAt?: string;

    @ApiPropertyOptional({ description: 'Consent date for data sharing' })
    @IsOptional()
    @IsDateString()
    dataShareConsentAt?: string;
}
