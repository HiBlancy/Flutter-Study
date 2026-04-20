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
exports.ProductService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = __importStar(require("mongoose"));
const cloudinary_service_1 = require("../cloudinary/cloudinary.service");
const image_compression_service_1 = require("../services/image-compression.service");
let ProductService = class ProductService {
    productModel;
    cloudinaryService;
    imageCompressionService;
    constructor(productModel, cloudinaryService, imageCompressionService) {
        this.productModel = productModel;
        this.cloudinaryService = cloudinaryService;
        this.imageCompressionService = imageCompressionService;
    }
    async create(userId, createProductDto) {
        const newProduct = new this.productModel({
            ...createProductDto,
            userId,
            listType: createProductDto.listType || 'have',
        });
        return newProduct.save();
    }
    async findAllByUserPaginated(userId, paginationDto, listType) {
        const { page, limit } = paginationDto;
        const skip = (page - 1) * limit;
        const filter = { userId };
        if (listType)
            filter.listType = listType;
        const [data, total] = await Promise.all([
            this.productModel
                .find(filter)
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .exec(),
            this.productModel.countDocuments(filter),
        ]);
        return {
            data,
            info: {
                totalProducts: total,
                totalPages: Math.ceil(total / limit),
                page,
                limit,
            },
        };
    }
    async findById(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            return null;
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No tienes permiso para ver este producto');
        }
        return product;
    }
    async update(id, userId, updateProductDto) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        const updateData = Object.fromEntries(Object.entries(updateProductDto).filter(([_, v]) => v !== undefined));
        this.applyBusinessRules(product, updateData);
        const updated = await this.productModel
            .findByIdAndUpdate(id, updateData, { returnDocument: 'after', runValidators: false })
            .exec();
        return updated;
    }
    applyBusinessRules(product, updateData) {
        if (product.isOpened && updateData.periodAfterOpening !== undefined) {
            const newExpiration = this.calculateExpirationDate(updateData.openedDate || product.openedDate, updateData.periodAfterOpening || product.periodAfterOpening, updateData.expirationDate !== undefined ? updateData.expirationDate : product.expirationDate);
            if (newExpiration)
                updateData.expirationDate = newExpiration;
        }
        if (updateData.isOpened === true && product.periodAfterOpening && !updateData.expirationDate) {
            const openedDate = updateData.openedDate || new Date();
            updateData.openedDate = openedDate;
            const calculated = this.calculateExpirationFromPeriod(openedDate, product.periodAfterOpening);
            if (calculated)
                updateData.expirationDate = calculated;
        }
    }
    async delete(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes eliminar este producto');
        }
        if (product.imageUrl) {
            const publicId = this.cloudinaryService.extractPublicIdFromUrl(product.imageUrl);
            if (publicId) {
                await this.cloudinaryService.deleteImage(publicId);
                console.log(`🗑️ Imagen eliminada de Cloudinary al borrar producto: ${publicId}`);
            }
        }
        return this.productModel.findByIdAndDelete(id).exec();
    }
    async moveToList(id, userId, targetList) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes mover este producto');
        }
        return this.productModel
            .findByIdAndUpdate(id, { listType: targetList }, { returnDocument: 'after' })
            .exec();
    }
    async markAsOpened(id, userId, customOpenedDate) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (product.isOpened) {
            throw new common_1.BadRequestException('El producto ya está abierto');
        }
        const openedDate = customOpenedDate || new Date();
        let finalExpiration = product.expirationDate;
        if (product.periodAfterOpening) {
            const calculatedExpiration = this.calculateExpirationFromPeriod(openedDate, product.periodAfterOpening);
            if (finalExpiration && calculatedExpiration) {
                finalExpiration = calculatedExpiration < finalExpiration ? calculatedExpiration : finalExpiration;
            }
            else if (calculatedExpiration) {
                finalExpiration = calculatedExpiration;
            }
        }
        const updated = await this.productModel
            .findByIdAndUpdate(id, { openedDate, isOpened: true, expirationDate: finalExpiration }, { returnDocument: 'after' })
            .exec();
        return updated;
    }
    async markAsClosed(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (!product.isOpened) {
            throw new common_1.BadRequestException('El producto no está abierto');
        }
        return this.productModel
            .findByIdAndUpdate(id, { isOpened: false }, { returnDocument: 'after' })
            .exec();
    }
    async calculateExpirationFromOpening(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product)
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        if (product.userId.toString() !== userId.toString()) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (!product.isOpened) {
            throw new common_1.BadRequestException('El producto no ha sido abierto aún');
        }
        if (!product.openedDate) {
            throw new common_1.BadRequestException('El producto no tiene fecha de apertura registrada');
        }
        if (!product.periodAfterOpening) {
            throw new common_1.BadRequestException('El producto no tiene período después de abierto definido');
        }
        const newExpiration = this.calculateExpirationDate(product.openedDate, product.periodAfterOpening, product.expirationDate);
        return this.productModel
            .findByIdAndUpdate(id, { expirationDate: newExpiration }, { returnDocument: 'after' })
            .exec();
    }
    async getStats(userId) {
        const stats = await this.productModel.aggregate([
            { $match: { userId: new mongoose_2.default.Types.ObjectId(userId) } },
            { $group: { _id: '$listType', count: { $sum: 1 } } },
        ]);
        const result = { wishlist: 0, have: 0, used: 0, total: 0 };
        stats.forEach(({ _id, count }) => { if (result[_id] !== undefined)
            result[_id] = count; });
        result.total = stats.reduce((acc, s) => acc + s.count, 0);
        return result;
    }
    async getExpiredProducts(userId) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return this.productModel
            .find({ userId, expirationDate: { $lt: today }, listType: { $ne: 'deleted' } })
            .sort({ expirationDate: 1 })
            .exec();
    }
    async getExpiringSoon(userId, days = 30) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const futureDate = new Date();
        futureDate.setDate(today.getDate() + days);
        futureDate.setHours(23, 59, 59, 999);
        return this.productModel
            .find({ userId, expirationDate: { $gte: today, $lte: futureDate }, listType: { $ne: 'deleted' } })
            .sort({ expirationDate: 1 })
            .exec();
    }
    calculateExpirationDate(baseDate, period, fixedExpiration) {
        if (!baseDate || !period)
            return fixedExpiration || null;
        const calculated = this.calculateExpirationFromPeriod(baseDate, period);
        if (!calculated)
            return fixedExpiration || null;
        if (fixedExpiration) {
            const fixed = new Date(fixedExpiration);
            return calculated < fixed ? calculated : fixed;
        }
        return calculated;
    }
    calculateExpirationFromPeriod(baseDate, period) {
        const months = this.parsePeriodToMonths(period);
        if (!months)
            return null;
        const expiration = new Date(baseDate);
        expiration.setMonth(expiration.getMonth() + months);
        return expiration;
    }
    parsePeriodToMonths(period) {
        if (!period)
            return null;
        const cleaned = period.trim().toUpperCase();
        const mMatch = cleaned.match(/^(\d+)\s*M$/);
        if (mMatch)
            return parseInt(mMatch[1]);
        const numberMatch = cleaned.match(/^(\d+)$/);
        if (numberMatch)
            return parseInt(numberMatch[1]);
        return null;
    }
    async uploadProductImage(productId, userId, fileBuffer, mimeType) {
        const product = await this.findById(productId, userId);
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${productId} no encontrado`);
        }
        console.log(`📸 Subiendo imagen para producto: ${product.name}`);
        const compressedBuffer = await this.imageCompressionService.compressProductImage(fileBuffer, mimeType);
        const imageUrl = await this.cloudinaryService.uploadImage(compressedBuffer, `product_${productId}_${Date.now()}`, 'products');
        if (product.imageUrl) {
            const publicId = this.cloudinaryService.extractPublicIdFromUrl(product.imageUrl);
            if (publicId) {
                await this.cloudinaryService.deleteImage(publicId);
                console.log(`🗑️ Imagen anterior eliminada: ${publicId}`);
            }
        }
        const updatedProduct = await this.update(productId, userId, { imageUrl });
        if (!updatedProduct) {
            throw new common_1.BadRequestException('No se pudo actualizar el producto con la nueva imagen');
        }
        console.log(`✅ Imagen actualizada para: ${product.name}`);
        return updatedProduct;
    }
    async deleteProductImage(productId, userId) {
        const product = await this.findById(productId, userId);
        if (!product)
            throw new common_1.NotFoundException(`Producto ${productId} no encontrado`);
        if (!product.imageUrl)
            throw new common_1.BadRequestException('El producto no tiene imagen');
        const publicId = this.cloudinaryService.extractPublicIdFromUrl(product.imageUrl);
        if (publicId) {
            await this.cloudinaryService.deleteImage(publicId);
            console.log(`🗑️ Imagen eliminada de Cloudinary: ${publicId}`);
        }
        const updatedProduct = await this.update(productId, userId, { imageUrl: null });
        if (!updatedProduct)
            throw new common_1.BadRequestException('No se pudo eliminar la imagen del producto');
        return updatedProduct;
    }
};
exports.ProductService = ProductService;
exports.ProductService = ProductService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Product')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        cloudinary_service_1.CloudinaryService,
        image_compression_service_1.ImageCompressionService])
], ProductService);
//# sourceMappingURL=product.service.js.map