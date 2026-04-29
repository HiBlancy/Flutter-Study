import { Model } from 'mongoose';
import { Routine } from './interfaces/routine.interface';
import { CreateRoutineDto } from './dto/create-routine.dto';
import { UpdateRoutineDto } from './dto/update-routine.dto';
import { ReorderProductsDto } from './dto/reorder-products.dto';
import { Product } from '../product/interfaces/product.interface';
export declare class RoutineService {
    private readonly routineModel;
    private readonly productModel;
    constructor(routineModel: Model<Routine>, productModel: Model<Product>);
    private toOrderedProducts;
    create(userId: string, createRoutineDto: CreateRoutineDto): Promise<Routine>;
    findAllByUser(userId: string): Promise<Routine[]>;
    findById(id: string, userId: string): Promise<Routine | null>;
    update(id: string, userId: string, updateRoutineDto: UpdateRoutineDto): Promise<Routine>;
    delete(id: string, userId: string): Promise<Routine>;
    reorderProducts(id: string, userId: string, reorderDto: ReorderProductsDto): Promise<Routine>;
    addProduct(id: string, userId: string, productId: string): Promise<Routine>;
    removeProduct(id: string, userId: string, productId: string): Promise<Routine>;
    private validateProducts;
}
