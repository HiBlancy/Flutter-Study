import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { MoveProductDto } from './dto/move-product.dto';
import { PaginationDto } from '../pagination/pagination.dto';
export declare class ProductController {
    private readonly productService;
    constructor(productService: ProductService);
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
}
