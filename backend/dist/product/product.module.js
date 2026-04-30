"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductModule = void 0;
const common_1 = require("@nestjs/common");
const product_controller_1 = require("./product.controller");
const product_service_1 = require("./product.service");
const mongoose_1 = require("@nestjs/mongoose");
const product_schema_1 = require("./schemas/product.schema");
const users_module_1 = require("../users/users.module");
const cloudinary_service_1 = require("../cloudinary/cloudinary.service");
const image_compression_service_1 = require("../services/image-compression.service");
const cleanup_service_1 = require("../monthly-stats/services/cleanup.service");
const monthly_stats_schema_1 = require("../monthly-stats/schemas/monthly-stats.schema");
const routine_schema_1 = require("../routines/schemas/routine.schema");
let ProductModule = class ProductModule {
};
exports.ProductModule = ProductModule;
exports.ProductModule = ProductModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: 'Product',
                    schema: product_schema_1.ProductSchema,
                    collection: 'products',
                },
                {
                    name: 'Routine',
                    schema: routine_schema_1.RoutineSchema,
                    collection: 'routines'
                },
                {
                    name: 'MonthlyStats',
                    schema: monthly_stats_schema_1.MonthlyStatsSchema,
                    collection: 'monthly_stats',
                },
            ]),
            users_module_1.UserModule
        ],
        controllers: [product_controller_1.ProductController],
        providers: [
            product_service_1.ProductService,
            cloudinary_service_1.CloudinaryService,
            image_compression_service_1.ImageCompressionService,
            cleanup_service_1.CleanupService,
        ],
        exports: [product_service_1.ProductService, mongoose_1.MongooseModule],
    })
], ProductModule);
//# sourceMappingURL=product.module.js.map