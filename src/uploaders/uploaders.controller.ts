import { Controller, Get, HttpCode, HttpStatus, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../utils/guard.js';
import { GenerateSignUrlQueryDto, GenerateSignUrlResDto } from './dto/uploaders.dto.js';
import { UploadersService } from './uploaders.service.js';

@ApiTags('Uploaders')
@Controller('uploaders')
export class UploadersController {
    constructor(private readonly uploadersService: UploadersService) {}

    @Get('generate-sign-url')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Generate Cloudinary image upload signature' })
    @ApiResponse({ status: 200, type: GenerateSignUrlResDto, description: 'Signature generated successfully.' })
    @ApiResponse({ status: 401, description: 'Unauthorized.' })
    public generateSignUrl(@Query() query: GenerateSignUrlQueryDto) {
        const data = this.uploadersService.generateImageSignature(query.folder);
        return { data, message: 'generate-sign-url success' };
    }
}
