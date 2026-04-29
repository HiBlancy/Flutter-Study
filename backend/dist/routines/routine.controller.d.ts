import { RoutineService } from './routine.service';
import { CreateRoutineDto } from './dto/create-routine.dto';
import { UpdateRoutineDto } from './dto/update-routine.dto';
import { ReorderProductsDto } from './dto/reorder-products.dto';
export declare class RoutineController {
    private readonly routineService;
    constructor(routineService: RoutineService);
    private successResponse;
    create(req: any, createRoutineDto: CreateRoutineDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    findAll(req: any): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    findOne(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    update(req: any, id: string, updateRoutineDto: UpdateRoutineDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    delete(req: any, id: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    reorderProducts(req: any, id: string, reorderDto: ReorderProductsDto): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    addProduct(req: any, id: string, productId: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
    removeProduct(req: any, id: string, productId: string): Promise<{
        status: boolean;
        message: string;
        data: any;
    }>;
}
