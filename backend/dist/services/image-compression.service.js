"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ImageCompressionService = void 0;
const common_1 = require("@nestjs/common");
const sharp_1 = __importDefault(require("sharp"));
let ImageCompressionService = class ImageCompressionService {
    async compressProfileImage(buffer, originalMime) {
        try {
            const metadata = await (0, sharp_1.default)(buffer).metadata();
            console.log(`📐 Imagen original: ${metadata.width}x${metadata.height}, ${(buffer.length / 1024).toFixed(2)}KB`);
            const MAX_WIDTH = 500;
            const MAX_HEIGHT = 500;
            const QUALITY = 80;
            let pipeline = (0, sharp_1.default)(buffer)
                .resize(MAX_WIDTH, MAX_HEIGHT, {
                fit: 'cover',
                position: 'centre'
            });
            if (originalMime === 'image/webp') {
                pipeline = pipeline.webp({ quality: QUALITY });
            }
            else if (originalMime === 'image/png') {
                pipeline = pipeline.png({ quality: QUALITY, compressionLevel: 9 });
            }
            else {
                pipeline = pipeline.jpeg({ quality: QUALITY, progressive: true });
            }
            const compressedBuffer = await pipeline.toBuffer();
            const compressedSizeKB = compressedBuffer.length / 1024;
            console.log(`✨ Imagen comprimida: ${(compressedBuffer.length / 1024).toFixed(2)}KB`);
            console.log(`💾 Ahorro: ${((1 - compressedBuffer.length / buffer.length) * 100).toFixed(1)}%`);
            if (compressedBuffer.length > 1024 * 1024) {
                throw new common_1.BadRequestException('La imagen después de comprimir es mayor a 1MB');
            }
            return compressedBuffer;
        }
        catch (error) {
            console.error('Error comprimiendo imagen:', error);
            throw new common_1.BadRequestException('Error al procesar la imagen');
        }
    }
    async compressProductImage(buffer, originalMime) {
        const metadata = await (0, sharp_1.default)(buffer).metadata();
        const MAX_WIDTH = 1200;
        const MAX_HEIGHT = 1200;
        const QUALITY = 85;
        let pipeline = (0, sharp_1.default)(buffer)
            .resize(MAX_WIDTH, MAX_HEIGHT, {
            fit: 'inside',
            withoutEnlargement: true
        });
        if (originalMime === 'image/webp') {
            pipeline = pipeline.webp({ quality: QUALITY });
        }
        else {
            pipeline = pipeline.jpeg({ quality: QUALITY, progressive: true });
        }
        return await pipeline.toBuffer();
    }
};
exports.ImageCompressionService = ImageCompressionService;
exports.ImageCompressionService = ImageCompressionService = __decorate([
    (0, common_1.Injectable)()
], ImageCompressionService);
//# sourceMappingURL=image-compression.service.js.map