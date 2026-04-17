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
exports.ProductController = void 0;
const common_1 = require("@nestjs/common");
const product_service_1 = require("./product.service");
const create_product_dto_1 = require("./dto/create-product.dto");
const update_product_dto_1 = require("./dto/update-product.dto");
const move_product_dto_1 = require("./dto/move-product.dto");
const auth_guard_1 = require("../users/guards/auth.guard");
const pagination_dto_1 = require("../pagination/pagination.dto");
const platform_express_1 = require("@nestjs/platform-express");
let ProductController = class ProductController {
    productService;
    constructor(productService) {
        this.productService = productService;
    }
    successResponse(message, data = null) {
        return { status: true, message, data };
    }
    async create(req, createProductDto) {
        const product = await this.productService.create(req.user._id, createProductDto);
        return this.successResponse('Producto añadido exitosamente', product);
    }
    async findAll(req, paginationDto, listType) {
        const result = await this.productService.findAllByUserPaginated(req.user._id, paginationDto, listType);
        return this.successResponse('Productos obtenidos con paginación', result);
    }
    async getStats(req) {
        const stats = await this.productService.getStats(req.user._id);
        return this.successResponse('Estadísticas obtenidas', stats);
    }
    async getExpired(req) {
        const products = await this.productService.getExpiredProducts(req.user._id);
        return this.successResponse('Productos caducados', products);
    }
    async getExpiringSoon(req, days) {
        const daysNum = days ? parseInt(days) : 30;
        const products = await this.productService.getExpiringSoon(req.user._id, daysNum);
        return this.successResponse(`Productos que caducan en ${daysNum} días`, products);
    }
    async findOne(req, id) {
        const product = await this.productService.findById(id, req.user._id);
        if (!product) {
            throw new common_1.NotFoundException(`Producto ${id} no encontrado`);
        }
        return this.successResponse('Producto obtenido', product);
    }
    async update(req, id, updateProductDto) {
        const product = await this.productService.update(id, req.user._id, updateProductDto);
        return this.successResponse('Producto actualizado', product);
    }
    async moveToList(req, id, moveProductDto) {
        const product = await this.productService.moveToList(id, req.user._id, moveProductDto.targetList);
        return this.successResponse('Producto movido de lista', product);
    }
    async delete(req, id) {
        const product = await this.productService.delete(id, req.user._id);
        return this.successResponse('Producto eliminado', product);
    }
    async markAsOpened(req, id, openedDateStr) {
        const customDate = openedDateStr ? new Date(openedDateStr) : undefined;
        const product = await this.productService.markAsOpened(id, req.user._id, customDate);
        return this.successResponse('Producto marcado como abierto', product);
    }
    async markAsClosed(req, id) {
        const product = await this.productService.markAsClosed(id, req.user._id);
        return this.successResponse('Producto marcado como cerrado', product);
    }
    async calculateExpiration(req, id) {
        const product = await this.productService.calculateExpirationFromOpening(id, req.user._id);
        return this.successResponse('Fecha de caducidad calculada', product);
    }
    async uploadProductImage(productId, file, req) {
        if (!file) {
            throw new common_1.BadRequestException('No se proporcionó ningún archivo');
        }
        try {
            const updatedProduct = await this.productService.uploadProductImage(productId, req.user._id, file.buffer, file.mimetype);
            return this.successResponse('Imagen de producto actualizada exitosamente', updatedProduct);
        }
        catch (error) {
            console.error('❌ Error al subir imagen:', error);
            if (error instanceof common_1.BadRequestException)
                throw error;
            if (error instanceof common_1.NotFoundException)
                throw error;
            throw new common_1.BadRequestException(error.message || 'Error al subir la imagen');
        }
    }
    async deleteProductImage(productId, req) {
        const updated = await this.productService.deleteProductImage(productId, req.user._id);
        return this.successResponse('Imagen de producto eliminada', updated);
    }
};
exports.ProductController = ProductController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, create_product_dto_1.CreateProductDto]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Query)()),
    __param(2, (0, common_1.Query)('listType')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, pagination_dto_1.PaginationDto, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)('stats/summary'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "getStats", null);
__decorate([
    (0, common_1.Get)('expired/all'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "getExpired", null);
__decorate([
    (0, common_1.Get)('expiring/soon'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Query)('days')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "getExpiringSoon", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "findOne", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, update_product_dto_1.UpdateProductDto]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "update", null);
__decorate([
    (0, common_1.Patch)(':id/move'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, move_product_dto_1.MoveProductDto]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "moveToList", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "delete", null);
__decorate([
    (0, common_1.Patch)(':id/open'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)('openedDate')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "markAsOpened", null);
__decorate([
    (0, common_1.Patch)(':id/close'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "markAsClosed", null);
__decorate([
    (0, common_1.Post)(':id/calculate-expiration'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "calculateExpiration", null);
__decorate([
    (0, common_1.Post)(':id/upload-image'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('productImage', {
        limits: { fileSize: 10 * 1024 * 1024 },
        fileFilter: (req, file, cb) => {
            const allowedMimes = ['image/jpeg', 'image/png', 'image/webp'];
            if (!allowedMimes.includes(file.mimetype)) {
                cb(new common_1.BadRequestException(`Tipo de archivo no permitido. Permitidos: ${allowedMimes.join(', ')}`), false);
            }
            else {
                cb(null, true);
            }
        },
    })),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.UploadedFile)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object, Object]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "uploadProductImage", null);
__decorate([
    (0, common_1.Delete)(':id/image'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "deleteProductImage", null);
exports.ProductController = ProductController = __decorate([
    (0, common_1.Controller)('products'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    __metadata("design:paramtypes", [product_service_1.ProductService])
], ProductController);
//# sourceMappingURL=product.controller.js.map