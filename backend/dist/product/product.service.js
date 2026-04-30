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
    routineModel;
    monthlyStatsModel;
    cloudinaryService;
    imageCompressionService;
    constructor(productModel, routineModel, monthlyStatsModel, cloudinaryService, imageCompressionService) {
        this.productModel = productModel;
        this.routineModel = routineModel;
        this.monthlyStatsModel = monthlyStatsModel;
        this.cloudinaryService = cloudinaryService;
        this.imageCompressionService = imageCompressionService;
    }
    async deleteCloudinaryImageByUrl(imageUrl, logPrefix) {
        if (!imageUrl)
            return;
        const publicId = this.cloudinaryService.extractPublicIdFromUrl(imageUrl);
        if (!publicId)
            return;
        await this.cloudinaryService.deleteImage(publicId);
        if (logPrefix)
            console.log(`${logPrefix}: ${publicId}`);
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
        return product;
    }
    async update(id, userId, updateProductDto) {
        try {
            const product = await this.productModel.findById(id).exec();
            if (!product) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
            }
            if (updateProductDto.expirationDate === '') {
                updateProductDto.expirationDate = null;
            }
            if (updateProductDto.openedDate === '') {
                updateProductDto.openedDate = null;
            }
            const updateData = Object.fromEntries(Object.entries(updateProductDto).filter(([_, v]) => v !== undefined));
            this.applyBusinessRules(product, updateData);
            const updated = await this.productModel
                .findByIdAndUpdate(id, updateData, {
                returnDocument: 'after',
                runValidators: false,
            })
                .exec();
            if (!updated) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado después de actualizar`);
            }
            return updated;
        }
        catch (error) {
            throw new common_1.NotFoundException(error, 'Producto no encontrado');
        }
    }
    applyBusinessRules(product, updateData) {
        if (product.isOpened &&
            updateData.periodAfterOpening !== undefined &&
            updateData.expirationDate !== null) {
            const newExpiration = this.calculateExpirationDate(updateData.openedDate || product.openedDate, updateData.periodAfterOpening || product.periodAfterOpening, updateData.expirationDate !== undefined
                ? updateData.expirationDate
                : product.expirationDate);
            if (newExpiration)
                updateData.expirationDate = newExpiration;
        }
        if (updateData.isOpened === true &&
            product.periodAfterOpening &&
            !updateData.expirationDate) {
            const openedDate = updateData.openedDate || new Date();
            updateData.openedDate = openedDate;
            const calculated = this.calculateExpirationFromPeriod(openedDate, product.periodAfterOpening);
            if (calculated)
                updateData.expirationDate = calculated;
        }
    }
    async delete(id, userId) {
        try {
            const product = await this.productModel.findById(id).exec();
            if (!product) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
            }
            await this.deleteCloudinaryImageByUrl(product.imageUrl);
            await this.routineModel.updateMany({ userId, 'products.productId': id }, { $pull: { products: { productId: id } } }).exec();
            const deleted = await this.productModel.findByIdAndDelete(id).exec();
            if (!deleted) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado después de eliminar`);
            }
            await this.reorderRoutinesProductsAfterDeletion(userId, id);
            return deleted;
        }
        catch (error) {
            throw new common_1.NotFoundException(error, `Producto ${id} no encontrado`);
        }
    }
    async reorderRoutinesProductsAfterDeletion(userId, productId) {
        const routines = await this.routineModel.find({ userId }).exec();
        for (const routine of routines) {
            const remainingProducts = routine.products.filter((p) => p.productId.toString() !== productId);
            const reordered = remainingProducts.map((p, idx) => ({
                productId: p.productId,
                order: idx,
            }));
            if (reordered.length !== routine.products.length) {
                routine.products = reordered;
                await routine.save();
            }
        }
    }
    async moveToList(id, userId, targetList) {
        try {
            const product = await this.productModel.findById(id).exec();
            if (!product) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
            }
            const updated = await this.productModel
                .findByIdAndUpdate(id, { listType: targetList }, { returnDocument: 'after' })
                .exec();
            if (!updated) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado después de mover`);
            }
            return updated;
        }
        catch (error) {
            throw new common_1.NotFoundException(error, `Producto ${id} no encontrado`);
        }
    }
    async markAsOpened(id, userId, customOpenedDate) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
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
        if (!updated) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado después de abrir`);
        }
        return updated;
    }
    async markAsClosed(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (!product.isOpened) {
            throw new common_1.BadRequestException('El producto no está abierto');
        }
        const expirationComesFromPAO = this.isExpirationFromPAO(product);
        const updateData = { isOpened: false };
        if (expirationComesFromPAO) {
            updateData.expirationDate = null;
            updateData.openedDate = null;
        }
        const updated = await this.productModel
            .findByIdAndUpdate(id, updateData, { returnDocument: 'after' })
            .exec();
        if (!updated) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado después de cerrar`);
        }
        return updated;
    }
    isExpirationFromPAO(product) {
        if (!product.expirationDate)
            return false;
        if (!product.periodAfterOpening)
            return false;
        if (!product.openedDate)
            return false;
        const paoExpiration = this.calculateExpirationFromPeriod(product.openedDate, product.periodAfterOpening);
        if (!paoExpiration)
            return false;
        return new Date(product.expirationDate).toDateString() === new Date(paoExpiration).toDateString();
    }
    async calculateExpirationFromOpening(id, userId) {
        try {
            const product = await this.productModel.findById(id).exec();
            if (!product) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
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
            const updated = await this.productModel
                .findByIdAndUpdate(id, { expirationDate: newExpiration }, { returnDocument: 'after' })
                .exec();
            if (!updated) {
                throw new common_1.NotFoundException(`Producto ${id} no encontrado después de actualizar`);
            }
            return updated;
        }
        catch (error) {
            throw new common_1.NotFoundException(error, `Producto ${id} no encontrado`);
        }
    }
    async getStats(userId) {
        const stats = await this.productModel.aggregate([
            { $match: { userId: new mongoose_2.default.Types.ObjectId(userId) } },
            { $group: { _id: '$listType', count: { $sum: 1 } } },
        ]);
        const result = { wishlist: 0, have: 0, used: 0, total: 0 };
        stats.forEach(({ _id, count }) => {
            if (result[_id] !== undefined)
                result[_id] = count;
        });
        result.total = stats.reduce((acc, s) => acc + s.count, 0);
        return result;
    }
    async getExpiredProducts(userId) {
        const today = new Date();
        today.setHours(23, 59, 59, 999);
        return this.productModel
            .find({
            userId,
            expirationDate: { $lte: today },
            listType: { $ne: 'used' },
        })
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
            .find({
            userId,
            expirationDate: { $gte: today, $lte: futureDate },
            listType: { $ne: 'used' },
        })
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
    async updateProductImage(productId, userId, fileBuffer, mimeType) {
        const product = await this.findById(productId, userId);
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${productId} no encontrado`);
        }
        const compressedBuffer = await this.imageCompressionService.compressProductImage(fileBuffer, mimeType);
        const imageUrl = await this.cloudinaryService.uploadImage(compressedBuffer, `product_${productId}_${Date.now()}`, 'products');
        await this.deleteCloudinaryImageByUrl(product.imageUrl, '🗑️ Imagen anterior del producto eliminada');
        const updatedProduct = await this.update(productId, userId, { imageUrl });
        console.log(`✅ Imagen actualizada para producto: ${product.name}`);
        return updatedProduct;
    }
    async deleteProductImage(productId, userId) {
        const product = await this.findById(productId, userId);
        if (!product)
            throw new common_1.NotFoundException(`Producto ${productId} no encontrado`);
        if (!product.imageUrl)
            throw new common_1.BadRequestException('El producto no tiene imagen');
        await this.deleteCloudinaryImageByUrl(product.imageUrl, '🗑️ Imagen eliminada de Cloudinary');
        const updatedProduct = await this.update(productId, userId, {
            imageUrl: null,
        });
        if (!updatedProduct)
            throw new common_1.BadRequestException('No se pudo eliminar la imagen del producto');
        return updatedProduct;
    }
    async getMonthlyHistory(userId) {
        const stats = await this.monthlyStatsModel
            .find({ userId })
            .sort({ year: -1, month: -1 })
            .exec();
        return {
            total: stats.length,
            data: stats.map((stat) => ({
                year: stat.year,
                month: stat.month,
                monthName: this.getMonthName(stat.month),
                productsUsedCount: stat.productsUsedCount,
                archivedAt: stat.archivedAt,
            })),
        };
    }
    async updateOrCreateMonthlyStats(userId, year, month, incrementCount) {
        const filter = {
            userId: new mongoose_2.default.Types.ObjectId(userId),
            year,
            month,
        };
        const update = {
            $inc: { productsUsedCount: incrementCount },
            $set: { archivedAt: new Date() },
        };
        const options = { upsert: true, returnDocument: 'after' };
        return this.monthlyStatsModel
            .findOneAndUpdate(filter, update, options)
            .exec();
    }
    async getYearlyOverview(userId) {
        const now = new Date();
        const startDate = new Date(now.getFullYear(), now.getMonth() - 11, 1);
        const endDate = new Date(now.getFullYear(), now.getMonth() + 1, 0);
        const stats = await this.monthlyStatsModel.aggregate([
            {
                $match: {
                    userId: new mongoose_2.default.Types.ObjectId(userId),
                    $expr: {
                        $and: [
                            {
                                $or: [
                                    { $gt: ['$year', startDate.getFullYear()] },
                                    {
                                        $and: [
                                            { $eq: ['$year', startDate.getFullYear()] },
                                            { $gte: ['$month', startDate.getMonth() + 1] },
                                        ],
                                    },
                                ],
                            },
                            {
                                $or: [
                                    { $lt: ['$year', endDate.getFullYear()] },
                                    {
                                        $and: [
                                            { $eq: ['$year', endDate.getFullYear()] },
                                            { $lte: ['$month', endDate.getMonth() + 1] },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                },
            },
            { $sort: { year: 1, month: 1 } },
        ]);
        const data = [];
        for (let i = 11; i >= 0; i--) {
            const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const year = date.getFullYear();
            const month = date.getMonth() + 1;
            const found = stats.find((s) => s.year === year && s.month === month);
            data.push({
                year,
                month,
                monthName: this.getMonthName(month),
                productsUsedCount: found ? found.productsUsedCount : 0,
                date: date.toISOString(),
            });
        }
        return {
            period: '12_months',
            data,
            total: data.reduce((sum, m) => sum + m.productsUsedCount, 0),
        };
    }
    async getCurrentMonthStats(userId) {
        const now = new Date();
        const year = now.getFullYear();
        const month = now.getMonth() + 1;
        const currentUsedCount = await this.productModel.countDocuments({
            userId,
            listType: 'used',
        });
        return {
            year,
            month,
            monthName: this.getMonthName(month),
            productsUsedCount: currentUsedCount,
            status: 'current',
        };
    }
    getMonthName(month) {
        const months = [
            'Enero',
            'Febrero',
            'Marzo',
            'Abril',
            'Mayo',
            'Junio',
            'Julio',
            'Agosto',
            'Septiembre',
            'Octubre',
            'Noviembre',
            'Diciembre',
        ];
        return months[month - 1] || '';
    }
};
exports.ProductService = ProductService;
exports.ProductService = ProductService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Product')),
    __param(1, (0, mongoose_1.InjectModel)('Routine')),
    __param(2, (0, mongoose_1.InjectModel)('MonthlyStats')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model,
        cloudinary_service_1.CloudinaryService,
        image_compression_service_1.ImageCompressionService])
], ProductService);
//# sourceMappingURL=product.service.js.map