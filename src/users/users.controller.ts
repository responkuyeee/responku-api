import { Body, Controller, Get, HttpCode, HttpStatus, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { type Request } from 'express';
import { AuthGuard } from '../utils/guard.js';
import { DomicileVerifyDto, UpdateUserProfileReqDto } from './dto/users.dto.js';
import { UsersService } from './users.service.js';

@ApiTags('Users')
@Controller('user')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}

    @Get('profile')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get current user profile' })
    @ApiResponse({ status: 200, description: 'User profile retrieved successfully.' })
    @ApiResponse({ status: 401, description: 'Unauthorized.' })
    @ApiResponse({ status: 404, description: 'User not found.' })
    public async getUserProfile(@Req() req: Request) {
        const userId = req.withUser!.id;
        const userProfile = await this.usersService.getUserProfile(userId);
        return { data: userProfile, message: 'get-profile success' };
    }

    @Patch('profile')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Update current user profile' })
    @ApiResponse({ status: 200, description: 'User profile updated successfully.' })
    @ApiResponse({ status: 401, description: 'Unauthorized.' })
    @ApiResponse({ status: 400, description: 'Bad Request.' })
    public async updateUserProfile(@Req() req: Request, @Body() dto: UpdateUserProfileReqDto) {
        const userId = req.withUser!.id;
        const updatedUser = await this.usersService.updateUserProfile(userId, dto);
        return { data: updatedUser, message: 'update-profile success' };
    }

    @Post('domicile-verify')
    @UseGuards(AuthGuard)
    @HttpCode(HttpStatus.OK)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Verify user domicile with coordinates' })
    @ApiResponse({ status: 200, description: 'User domicile verified successfully.' })
    @ApiResponse({ status: 401, description: 'Unauthorized.' })
    @ApiResponse({ status: 400, description: 'Bad Request.' })
    public async verifyDomicile(@Req() req: Request, @Body() dto: DomicileVerifyDto) {
        const userId = req.withUser!.id;
        const data = await this.usersService.verifyDomicile(userId, dto);
        return { data, message: 'domicile-verify success' };
    }
}
