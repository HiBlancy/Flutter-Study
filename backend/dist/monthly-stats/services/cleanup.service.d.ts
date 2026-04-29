import { Model } from 'mongoose';
import { CloudinaryService } from '../../cloudinary/cloudinary.service';
import { Product } from '../../product/interfaces/product.interface';
import { ProductService } from '../../product/product.service';
export declare class CleanupService {
    private readonly productModel;
    private readonly productService;
    private readonly cloudinaryService;
    private readonly logger;
    constructor(productModel: Model<Product>, productService: ProductService, cloudinaryService: CloudinaryService);
    cleanupUsedProducts(): Promise<void>;
    testCleanupNow(): Promise<{
        success: boolean;
        message: string;
    }>;
    private executeCleanup;
}
