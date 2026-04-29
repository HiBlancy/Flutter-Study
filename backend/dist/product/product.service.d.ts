import mongoose, { Model } from 'mongoose';
import { Product } from './interfaces/product.interface';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { PaginationDto } from '../pagination/pagination.dto';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { ImageCompressionService } from 'src/services/image-compression.service';
import { MonthlyStats } from '../monthly-stats/interfaces/monthly-stats.interface';
export declare class ProductService {
    private readonly productModel;
    private readonly monthlyStatsModel;
    private readonly cloudinaryService;
    private readonly imageCompressionService;
    constructor(productModel: Model<Product>, monthlyStatsModel: Model<MonthlyStats>, cloudinaryService: CloudinaryService, imageCompressionService: ImageCompressionService);
    private deleteCloudinaryImageByUrl;
    create(userId: string, createProductDto: CreateProductDto): Promise<Product>;
    findAllByUserPaginated(userId: string, paginationDto: PaginationDto, listType?: string): Promise<{
        data: (mongoose.Document<unknown, {}, Product, {}, mongoose.DefaultSchemaOptions> & Product & Required<{
            _id: string;
        }> & {
            __v: number;
        } & {
            id: string;
        })[];
        info: {
            totalProducts: number;
            totalPages: number;
            page: number;
            limit: number;
        };
    }>;
    findById(id: string, userId: string): Promise<Product | null>;
    update(id: string, userId: string, updateProductDto: UpdateProductDto): Promise<Product>;
    private applyBusinessRules;
    delete(id: string, userId: string): Promise<Product>;
    moveToList(id: string, userId: string, targetList: string): Promise<Product>;
    markAsOpened(id: string, userId: string, customOpenedDate?: Date): Promise<Product>;
    markAsClosed(id: string, userId: string): Promise<Product>;
    private isExpirationFromPAO;
    calculateExpirationFromOpening(id: string, userId: string): Promise<Product>;
    getStats(userId: string): Promise<{
        wishlist: number;
        have: number;
        used: number;
        total: number;
    }>;
    getExpiredProducts(userId: string): Promise<Product[]>;
    getExpiringSoon(userId: string, days?: number): Promise<Product[]>;
    private calculateExpirationDate;
    private calculateExpirationFromPeriod;
    private parsePeriodToMonths;
    updateProductImage(productId: string, userId: string, fileBuffer: Buffer, mimeType: string): Promise<Product>;
    deleteProductImage(productId: string, userId: string): Promise<Product>;
    getMonthlyHistory(userId: string): Promise<any>;
    updateOrCreateMonthlyStats(userId: string, year: number, month: number, incrementCount: number): Promise<(mongoose.Document<unknown, {}, MonthlyStats, {}, mongoose.DefaultSchemaOptions> & MonthlyStats & {
        _id: mongoose.Types.ObjectId;
    } & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    getYearlyOverview(userId: string): Promise<any>;
    getCurrentMonthStats(userId: string): Promise<any>;
    private getMonthName;
}
