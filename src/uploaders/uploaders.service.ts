import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v2 as cloudinary } from 'cloudinary';

@Injectable()
export class UploadersService {
    constructor(private readonly configService: ConfigService) {
        cloudinary.config({
            cloud_name: this.configService.getOrThrow<string>('CLOUDINARY_CLOUD_NAME'),
            api_key: this.configService.getOrThrow<string>('CLOUDINARY_API_KEY'),
            api_secret: this.configService.getOrThrow<string>('CLOUDINARY_API_SECRET')
        });
    }

    generateImageSignature(folder?: string) {
        const timestamp = Math.round(new Date().getTime() / 1000);
        const paramsToSign: Record<string, any> = { timestamp };

        if (folder) paramsToSign.folder = folder;
        const signature = cloudinary.utils.api_sign_request(paramsToSign, this.configService.getOrThrow<string>('CLOUDINARY_API_SECRET'));

        return {
            timestamp,
            signature,
            cloudName: this.configService.getOrThrow<string>('CLOUDINARY_CLOUD_NAME'),
            apiKey: this.configService.getOrThrow<string>('CLOUDINARY_API_KEY'),
            folder: folder ?? null
        };
    }
}
