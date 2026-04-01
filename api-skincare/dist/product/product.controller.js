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
    async findAll(req, listType) {
        const products = await this.productService.findAllByUser(req.user._id, listType);
        return this.successResponse('Productos obtenidos', products);
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
    async markAsOpened(req, id) {
        const product = await this.productService.markAsOpened(id, req.user._id);
        return this.successResponse('Producto marcado como abierto', product);
    }
    async calculateExpiration(req, id) {
        const product = await this.productService.calculateExpirationFromOpening(id, req.user._id);
        return this.successResponse('Fecha de caducidad calculada', product);
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
    __param(1, (0, common_1.Query)('listType')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
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
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "markAsOpened", null);
__decorate([
    (0, common_1.Post)(':id/calculate-expiration'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], ProductController.prototype, "calculateExpiration", null);
exports.ProductController = ProductController = __decorate([
    (0, common_1.Controller)('products'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    __metadata("design:paramtypes", [product_service_1.ProductService])
], ProductController);
//# sourceMappingURL=product.controller.js.map