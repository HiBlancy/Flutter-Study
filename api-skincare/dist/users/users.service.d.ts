import { Model } from 'mongoose';
import { User } from './interfaces/user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Product } from '../product/interfaces/product.interface';
import { Routine } from '../routines/interfaces/routine.interface';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
export declare class UsersService {
    private readonly userModel;
    private productModel;
    private routineModel;
    private cloudinaryService;
    constructor(userModel: Model<User>, productModel: Model<Product>, routineModel: Model<Routine>, cloudinaryService: CloudinaryService);
    create(createUserDto: CreateUserDto): Promise<User>;
    findOne(condition: any): Promise<User | null>;
    findById(id: string): Promise<User | null>;
    getAllUsers(): Promise<User[]>;
    update(id: string, updateUserDto: UpdateUserDto): Promise<User | null>;
    delete(id: string): Promise<User | null>;
}
