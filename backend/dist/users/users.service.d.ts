import { Model } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Product } from '../product/interfaces/product.interface';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { ImageCompressionService } from '../services/image-compression.service';
export declare class UsersService {
    private readonly userModel;
    private productModel;
    private cloudinaryService;
    private readonly imageCompressionService;
    constructor(userModel: Model<User>, productModel: Model<Product>, cloudinaryService: CloudinaryService, imageCompressionService: ImageCompressionService);
    private deleteCloudinaryImageByUrl;
    create(createUserDto: CreateUserDto): Promise<User>;
    findOne(condition: any): Promise<User | null>;
    findById(id: string): Promise<User | null>;
    getAllUsers(): Promise<User[]>;
    update(id: string, updateUserDto: UpdateUserDto): Promise<User | null>;
    delete(id: string): Promise<User | null>;
    deleteProfileImage(userId: string): Promise<User>;
    updateProfileImage(userId: string, fileBuffer: Buffer, mimeType: string): Promise<User>;
}
