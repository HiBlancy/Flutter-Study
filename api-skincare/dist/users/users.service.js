"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const bcrypt = __importStar(require("bcrypt"));
const cloudinary_service_1 = require("../cloudinary/cloudinary.service");
let UsersService = class UsersService {
    userModel;
    productModel;
    routineModel;
    cloudinaryService;
    constructor(userModel, productModel, routineModel, cloudinaryService) {
        this.userModel = userModel;
        this.productModel = productModel;
        this.routineModel = routineModel;
        this.cloudinaryService = cloudinaryService;
    }
    async create(createUserDto) {
        const emailExists = await this.userModel.findOne({
            email: createUserDto.email.toLowerCase(),
        });
        if (emailExists) {
            throw new common_1.ConflictException('El email ya está registrado');
        }
        const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
        const newUser = new this.userModel({
            ...createUserDto,
            email: createUserDto.email.toLowerCase(),
            password: hashedPassword,
        });
        return newUser.save();
    }
    async findOne(condition) {
        return this.userModel.findOne(condition).exec();
    }
    async findById(id) {
        return this.userModel.findById(id).exec();
    }
    async getAllUsers() {
        return this.userModel.find().select('-password').exec();
    }
    async update(id, updateUserDto) {
        if (updateUserDto.email) {
            const emailExists = await this.userModel.findOne({
                email: updateUserDto.email.toLowerCase(),
                _id: { $ne: id },
            });
            if (emailExists) {
                throw new common_1.ConflictException('El email ya está registrado por otro usuario');
            }
            updateUserDto.email = updateUserDto.email.toLowerCase();
        }
        if (updateUserDto.password) {
            updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
        }
        if (updateUserDto.birthDate) {
            updateUserDto.birthDate = new Date(updateUserDto.birthDate);
        }
        const updated = await this.userModel
            .findByIdAndUpdate(id, updateUserDto, { returnDocument: 'after' })
            .select('-password')
            .exec();
        if (!updated) {
            throw new common_1.NotFoundException(`Usuario ${id} no encontrado`);
        }
        return updated;
    }
    async delete(id) {
        const user = await this.userModel.findById(id);
        if (!user) {
            throw new common_1.NotFoundException(`Usuario ${id} no encontrado`);
        }
        const products = await this.productModel
            .find({ userId: id })
            .select('imageUrl')
            .exec();
        for (const product of products) {
            if (product.imageUrl) {
                const publicId = this.cloudinaryService.extractPublicIdFromUrl(product.imageUrl);
                if (publicId) {
                    await this.cloudinaryService.deleteImage(publicId);
                    console.log(`🗑️ Imagen de producto eliminada: ${publicId}`);
                }
            }
        }
        if (user.profileImage) {
            const publicId = this.cloudinaryService.extractPublicIdFromUrl(user.profileImage);
            if (publicId) {
                await this.cloudinaryService.deleteImage(publicId);
                console.log(`🗑️ Imagen de perfil eliminada: ${publicId}`);
            }
        }
        await this.productModel.deleteMany({ userId: id });
        await this.routineModel.deleteMany({ userId: id });
        const deletedUser = await this.userModel
            .findByIdAndDelete(id)
            .select('-password')
            .exec();
        return deletedUser;
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Users')),
    __param(1, (0, mongoose_1.InjectModel)('Product')),
    __param(2, (0, mongoose_1.InjectModel)('Routine')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model,
        cloudinary_service_1.CloudinaryService])
], UsersService);
//# sourceMappingURL=users.service.js.map