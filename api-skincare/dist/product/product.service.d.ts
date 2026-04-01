import { Model } from 'mongoose';
import { Product } from './interfaces/product.interface';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
export declare class ProductService {
    private readonly productModel;
    constructor(productModel: Model<Product>);
    create(userId: string, createProductDto: CreateProductDto): Promise<Product>;
    findAllByUser(userId: string, listType?: string): Promise<Product[]>;
    findById(id: string, userId: string): Promise<Product | null>;
    update(id: string, userId: string, updateProductDto: UpdateProductDto): Promise<Product | null>;
    delete(id: string, userId: string): Promise<Product | null>;
    moveToList(id: string, userId: string, targetList: string): Promise<Product | null>;
    getStats(userId: string): Promise<{
        wishlist: number;
        favorites: number;
        have: number;
        used: number;
        deleted: number;
        total: number;
    }>;
    getExpiredProducts(userId: string): Promise<Product[]>;
    getExpiringSoon(userId: string, days?: number): Promise<Product[]>;
    markAsOpened(id: string, userId: string): Promise<Product | null>;
    calculateExpirationFromOpening(id: string, userId: string): Promise<Product | null>;
    updateSimple(id: string, updateData: any): Promise<Product | null>;
}
