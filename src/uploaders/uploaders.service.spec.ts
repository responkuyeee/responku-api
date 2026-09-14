import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { UploadersService } from './uploaders.service.js';

describe('UploadersService', () => {
    let service: UploadersService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                UploadersService,
                {
                    provide: ConfigService,
                    useValue: {
                        getOrThrow: (key: string) => `mock-${key}`
                    }
                }
            ]
        }).compile();

        service = module.get<UploadersService>(UploadersService);
    });

    it('should be defined', () => {
        expect(service).toBeDefined();
    });
});
