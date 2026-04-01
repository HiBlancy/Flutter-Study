"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
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
const mongoose_2 = require("mongoose");
let ProductService = class ProductService {
    productModel;
    constructor(productModel) {
        this.productModel = productModel;
    }
    async create(userId, createProductDto) {
        if (createProductDto.barcode) {
            const existing = await this.productModel.findOne({
                userId,
                barcode: createProductDto.barcode,
                listType: createProductDto.listType || 'have'
            });
            if (existing) {
                throw new common_1.ConflictException('Este producto ya está en tu lista');
            }
        }
        const newProduct = new this.productModel({
            ...createProductDto,
            userId,
            listType: createProductDto.listType || 'have',
        });
        return newProduct.save();
    }
    async findAllByUser(userId, listType) {
        const filter = { userId };
        if (listType) {
            filter.listType = listType;
        }
        return this.productModel
            .find(filter)
            .sort({ createdAt: -1 })
            .exec();
    }
    async findById(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            return null;
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No tienes permiso para ver este producto');
        }
        return product;
    }
    async update(id, userId, updateProductDto) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (updateProductDto.barcode && updateProductDto.barcode !== product.barcode) {
            const existing = await this.productModel.findOne({
                userId,
                barcode: updateProductDto.barcode,
                listType: updateProductDto.listType || product.listType,
                _id: { $ne: id }
            });
            if (existing) {
                throw new common_1.ConflictException('Ya tienes otro producto con este código de barras');
            }
        }
        const updated = await this.productModel
            .findByIdAndUpdate(id, updateProductDto, { returnDocument: 'after' })
            .exec();
        return updated;
    }
    async delete(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No puedes eliminar este producto');
        }
        const deleted = await this.productModel.findByIdAndDelete(id).exec();
        return deleted;
    }
    async moveToList(id, userId, targetList) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No puedes mover este producto');
        }
        if (product.barcode && product.listType !== targetList) {
            const existing = await this.productModel.findOne({
                userId,
                barcode: product.barcode,
                listType: targetList
            });
            if (existing) {
                throw new common_1.ConflictException(`Este producto ya está en la lista ${targetList}`);
            }
        }
        const updated = await this.productModel
            .findByIdAndUpdate(id, { listType: targetList }, { returnDocument: 'after' })
            .exec();
        return updated;
    }
    async getStats(userId) {
        const products = await this.productModel.find({ userId }).exec();
        const stats = {
            wishlist: 0,
            favorites: 0,
            have: 0,
            used: 0,
            deleted: 0,
            total: products.length
        };
        products.forEach(product => {
            if (stats[product.listType] !== undefined) {
                stats[product.listType]++;
            }
        });
        return stats;
    }
    async getExpiredProducts(userId) {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return this.productModel
            .find({
            userId,
            expirationDate: { $lt: today },
            listType: { $ne: 'deleted' }
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
            listType: { $ne: 'deleted' }
        })
            .sort({ expirationDate: 1 })
            .exec();
    }
    async markAsOpened(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (product.openedDate) {
            throw new common_1.BadRequestException('El producto ya estaba marcado como abierto');
        }
        const updated = await this.productModel
            .findByIdAndUpdate(id, { openedDate: new Date() }, { returnDocument: 'after' })
            .exec();
        return updated;
    }
    async calculateExpirationFromOpening(id, userId) {
        const product = await this.productModel.findById(id).exec();
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        if (product.userId.toString() !== userId) {
            throw new common_1.ForbiddenException('No puedes modificar este producto');
        }
        if (!product.openedDate) {
            throw new common_1.BadRequestException('El producto no ha sido abierto aún');
        }
        if (!product.periodAfterOpening) {
            throw new common_1.BadRequestException('El producto no tiene período después de abierto definido');
        }
        const months = parseInt(product.periodAfterOpening);
        if (isNaN(months)) {
            throw new common_1.BadRequestException('Período después de abierto inválido');
        }
        const expirationDate = new Date(product.openedDate);
        expirationDate.setMonth(expirationDate.getMonth() + months);
        const updated = await this.productModel
            .findByIdAndUpdate(id, { expirationDate }, { returnDocument: 'after' })
            .exec();
        return updated;
    }
    async updateSimple(id, updateData) {
        const updated = await this.productModel
            .findByIdAndUpdate(id, updateData, { returnDocument: 'after' })
            .exec();
        if (!updated) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        return updated;
    }
};
exports.ProductService = ProductService;
exports.ProductService = ProductService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Product')),
    __metadata("design:paramtypes", [mongoose_2.Model])
], ProductService);
//# sourceMappingURL=product.service.js.map