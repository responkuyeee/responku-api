import { Body, Controller, HttpCode, HttpStatus, Patch, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { type Request } from 'express';
import { AuthGuard } from '../utils/guard.js';
import { UpdateUserProfileReqDto } from './dto/users.dto.js';
import { UsersService } from './users.service.js';

@ApiTags('Users')
@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}

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
}
