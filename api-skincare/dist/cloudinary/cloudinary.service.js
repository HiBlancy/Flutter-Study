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
Object.defineProperty(exports, "__esModule", { value: true });
exports.CloudinaryService = void 0;
const common_1 = require("@nestjs/common");
const cloudinary_1 = require("cloudinary");
const stream_1 = require("stream");
let CloudinaryService = class CloudinaryService {
    constructor() {
        cloudinary_1.v2.config({
            cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
            api_key: process.env.CLOUDINARY_API_KEY,
            api_secret: process.env.CLOUDINARY_API_SECRET,
        });
    }
    async uploadImage(fileBuffer, fileName, folder = 'user-profiles') {
        return new Promise((resolve, reject) => {
            const stream = stream_1.Readable.from(fileBuffer);
            const uploadStream = cloudinary_1.v2.uploader.upload_stream({
                folder: folder,
                public_id: `${Date.now()}_${fileName}`,
                resource_type: 'auto',
                quality: 'auto',
                fetch_format: 'auto',
                width: 500,
                height: 500,
                crop: 'fill',
                gravity: 'face',
                dpr: 'auto',
            }, (error, result) => {
                if (error) {
                    console.error('❌ Error en Cloudinary:', error);
                    reject(error);
                }
                else if (result && result.secure_url) {
                    console.log('✅ Imagen subida a Cloudinary:', result.secure_url);
                    resolve(result.secure_url);
                }
                else {
                    reject(new Error('No se recibió URL de Cloudinary'));
                }
            });
            stream.pipe(uploadStream);
        });
    }
    async deleteImage(publicId) {
        try {
            const result = await cloudinary_1.v2.uploader.destroy(publicId);
            console.log('✅ Imagen eliminada de Cloudinary:', publicId);
            return result.result === 'ok';
        }
        catch (error) {
            console.error('❌ Error eliminando imagen:', error);
            return false;
        }
    }
    extractPublicIdFromUrl(url) {
        try {
            const match = url.match(/\/upload\/(?:v\d+\/)?(.+?)\.(jpg|jpeg|png|webp|gif)(?:\?|$)/i);
            if (match && match[1]) {
                return match[1];
            }
            const simpleMatch = url.match(/\/([^\/]+\/[^\/]+)\.[a-z]+$/i);
            return simpleMatch ? simpleMatch[1] : null;
        }
        catch (error) {
            console.error('❌ Error extrayendo public_id:', error);
            return null;
        }
    }
};
exports.CloudinaryService = CloudinaryService;
exports.CloudinaryService = CloudinaryService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [])
], CloudinaryService);
//# sourceMappingURL=cloudinary.service.js.map