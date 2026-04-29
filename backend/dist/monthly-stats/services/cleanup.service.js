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
var CleanupService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.CleanupService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const schedule_1 = require("@nestjs/schedule");
const cloudinary_service_1 = require("../../cloudinary/cloudinary.service");
const product_service_1 = require("../../product/product.service");
let CleanupService = CleanupService_1 = class CleanupService {
    productModel;
    productService;
    cloudinaryService;
    logger = new common_1.Logger(CleanupService_1.name);
    constructor(productModel, productService, cloudinaryService) {
        this.productModel = productModel;
        this.productService = productService;
        this.cloudinaryService = cloudinaryService;
    }
    async cleanupUsedProducts() {
        this.logger.log('🧹 [CRON] Iniciando limpieza mensual de productos usados');
        await this.executeCleanup(false);
    }
    async testCleanupNow() {
        try {
            this.logger.log('🧪 [TEST] Ejecutando limpieza de pruebas (mes actual)');
            await this.executeCleanup(true);
            return {
                success: true,
                message: 'Limpieza de pruebas ejecutada exitosamente',
            };
        }
        catch (error) {
            this.logger.error(`❌ Error en limpieza de pruebas: ${error.message}`);
            return { success: false, message: `Error: ${error.message}` };
        }
    }
    async executeCleanup(useCurrentMonth) {
        try {
            const now = new Date();
            let year;
            let month;
            if (useCurrentMonth) {
                year = now.getFullYear();
                month = now.getMonth() + 1;
                this.logger.log(`Archivando productos para el mes actual: ${month}/${year}`);
            }
            else {
                if (now.getMonth() === 0) {
                    year = now.getFullYear() - 1;
                    month = 12;
                }
                else {
                    year = now.getFullYear();
                    month = now.getMonth();
                }
                this.logger.log(`Archivando productos para el mes anterior: ${month}/${year}`);
            }
            const usersWithUsed = await this.productModel.aggregate([
                { $match: { listType: 'used' } },
                {
                    $group: {
                        _id: '$userId',
                        productIds: { $push: '$_id' },
                        imageUrls: { $push: '$imageUrl' },
                    },
                },
            ]);
            if (usersWithUsed.length === 0) {
                this.logger.log('No hay productos usados para limpiar');
                return;
            }
            for (const userData of usersWithUsed) {
                const userId = userData._id.toString();
                const count = userData.productIds.length;
                const imageUrls = userData.imageUrls.filter((url) => url != null);
                await this.productService.updateOrCreateMonthlyStats(userId, year, month, count);
                for (const url of imageUrls) {
                    const publicId = this.cloudinaryService.extractPublicIdFromUrl(url);
                    if (publicId) {
                        try {
                            await this.cloudinaryService.deleteImage(publicId);
                            this.logger.debug(`Imagen eliminada: ${publicId}`);
                        }
                        catch (err) {
                            this.logger.warn(`Error eliminando imagen ${publicId}: ${err.message}`);
                        }
                    }
                }
                await this.productModel.deleteMany({
                    _id: { $in: userData.productIds },
                });
                this.logger.log(`Usuario ${userId}: ${count} productos usados archivados (${month}/${year})`);
            }
            this.logger.log('✅ Limpieza completada');
        }
        catch (error) {
            this.logger.error(`❌ Error en limpieza: ${error.message}`, error.stack);
            throw error;
        }
    }
};
exports.CleanupService = CleanupService;
__decorate([
    (0, schedule_1.Cron)('0 0 1 * *'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CleanupService.prototype, "cleanupUsedProducts", null);
exports.CleanupService = CleanupService = CleanupService_1 = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)('Product')),
    __metadata("design:paramtypes", [mongoose_2.Model,
        product_service_1.ProductService,
        cloudinary_service_1.CloudinaryService])
], CleanupService);
//# sourceMappingURL=cleanup.service.js.map