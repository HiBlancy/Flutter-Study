import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { MoveProductDto } from './dto/move-product.dto';
import { PaginationDto } from '../pagination/pagination.dto';
import { CleanupService } from '../monthly-stats/services/cleanup.service';
export declare class ProductController {
    private readonly productService;
    private readonly cleanupService;
    constructor(productService: ProductService, cleanupService: CleanupService);
    private successResponse;
    create(req: any, createProductDto: CreateProductDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    findAll(req: any, paginationDto: PaginationDto, listType?: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getStats(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getExpired(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getExpiringSoon(req: any, days?: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    findOne(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    update(req: any, id: string, updateProductDto: UpdateProductDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    moveToList(req: any, id: string, moveProductDto: MoveProductDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    delete(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    markAsOpened(req: any, id: string, openedDateStr?: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    markAsClosed(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    calculateExpiration(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    uploadProductImage(productId: string, file: Express.Multer.File, req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    deleteProductImage(productId: string, req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getMonthlyHistory(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getYearlyOverview(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    getCurrentMonthStats(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    triggerTestCleanup(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    triggerCleanup(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
}
