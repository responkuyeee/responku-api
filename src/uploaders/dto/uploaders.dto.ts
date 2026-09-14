import { ApiPropertyOptional, ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class GenerateSignUrlQueryDto {
    @ApiPropertyOptional({ example: 'avatars', description: 'The folder to upload the image to in Cloudinary' })
    @IsOptional()
    @IsString()
    folder?: string;
}

export class GenerateSignUrlResDto {
    @ApiProperty({ example: 1700000000, description: 'Unix timestamp' })
    timestamp: number;

    @ApiProperty({ example: 'a1b2c3d4...', description: 'Cloudinary signature' })
    signature: string;

    @ApiProperty({ example: 'my_cloud_name', description: 'Cloudinary cloud name' })
    cloudName: string;

    @ApiProperty({ example: '123456789012345', description: 'Cloudinary API key' })
    apiKey: string;

    @ApiPropertyOptional({ example: 'avatars', description: 'The folder the signature is valid for' })
    folder?: string;
}
