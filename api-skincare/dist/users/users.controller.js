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
exports.UsersController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const users_service_1 = require("./users.service");
const create_user_dto_1 = require("./dto/create-user.dto");
const update_user_dto_1 = require("./dto/update-user.dto");
const jwt_1 = require("@nestjs/jwt");
const auth_guard_1 = require("./guards/auth.guard");
const cloudinary_service_1 = require("../cloudinary/cloudinary.service");
const image_compression_service_1 = require("../services/image-compression.service");
function createMulterImageFilter(allowedMimes) {
    return (req, file, cb) => {
        if (!allowedMimes.includes(file.mimetype)) {
            cb(new common_1.BadRequestException(`Tipo de archivo no permitido. Permitidos: ${allowedMimes.join(', ')}`), false);
        }
        else {
            cb(null, true);
        }
    };
}
let UsersController = class UsersController {
    usersService;
    jwtService;
    cloudinaryService;
    imageCompressionService;
    constructor(usersService, jwtService, cloudinaryService, imageCompressionService) {
        this.usersService = usersService;
        this.jwtService = jwtService;
        this.cloudinaryService = cloudinaryService;
        this.imageCompressionService = imageCompressionService;
    }
    successResponse(message, data = null) {
        return { status: true, message, data };
    }
    async register(createUserDto) {
        try {
            const user = await this.usersService.create({
                ...createUserDto,
                email: createUserDto.email.toLowerCase(),
            });
            const token = await this.jwtService.signAsync({
                _id: user._id,
                email: user.email,
                name: user.name,
            });
            return this.successResponse('Usuario registrado exitosamente', {
                user,
                token,
            });
        }
        catch (error) {
            if (error instanceof common_1.ConflictException)
                throw error;
            throw new common_1.BadRequestException(error.message || 'Error al crear usuario');
        }
    }
    async login(body) {
        try {
            const user = await this.usersService.findOne({
                email: body.email.toLowerCase(),
            });
            if (!user || !(await user.comparePassword(body.password))) {
                throw new common_1.UnauthorizedException('Credenciales incorrectas');
            }
            const token = await this.jwtService.signAsync({
                _id: user._id,
                email: user.email,
                name: user.name,
            });
            return this.successResponse('Login exitoso', { user, token });
        }
        catch (error) {
            if (error instanceof common_1.UnauthorizedException)
                throw error;
            throw new common_1.BadRequestException(error.message || 'Error en login');
        }
    }
    async getProfile(req) {
        return this.successResponse('Perfil obtenido', req.user);
    }
    async updateProfile(updateUserDto, req) {
        const updatedUser = await this.usersService.update(req.user._id, updateUserDto);
        return this.successResponse('Perfil actualizado', updatedUser);
    }
    async uploadProfileImage(file, req) {
        try {
            if (!file) {
                throw new common_1.BadRequestException('No se proporcionó ningún archivo');
            }
            const compressedBuffer = await this.imageCompressionService.compressProfileImage(file.buffer, file.mimetype);
            console.log(`✅ Imagen comprimida exitosamente`);
            const imageUrl = await this.cloudinaryService.uploadImage(compressedBuffer, `${req.user._id}_profile_${Date.now()}`, 'user-profiles');
            const currentUser = await this.usersService.findById(req.user._id);
            if (currentUser?.profileImage) {
                const publicId = this.cloudinaryService.extractPublicIdFromUrl(currentUser.profileImage);
                if (publicId) {
                    await this.cloudinaryService.deleteImage(publicId);
                    console.log(`🗑️ Imagen anterior eliminada: ${publicId}`);
                }
            }
            const updateDto = {
                profileImage: imageUrl,
            };
            const updatedUser = await this.usersService.update(req.user._id, updateDto);
            console.log(`✅ Imagen de perfil actualizada para usuario ${req.user._id}`);
            console.log(`   - URL: ${imageUrl}`);
            return this.successResponse('Imagen de perfil actualizada exitosamente', updatedUser);
        }
        catch (error) {
            console.error('❌ Error al subir imagen:', error);
            if (error instanceof common_1.BadRequestException)
                throw error;
            throw new common_1.BadRequestException(error.message || 'Error al subir la imagen');
        }
    }
    async findAllUsers() {
        const users = await this.usersService.getAllUsers();
        return this.successResponse('Usuarios obtenidos', users);
    }
    async deleteMyAccount(req) {
        const userId = req.user._id;
        const deletedUser = await this.usersService.delete(userId);
        return this.successResponse('Cuenta eliminada exitosamente', deletedUser);
    }
    async deleteProfileImage(req) {
        try {
            const userId = req.user._id;
            const user = await this.usersService.findById(userId);
            if (!user) {
                throw new common_1.NotFoundException('Usuario no encontrado');
            }
            if (!user.profileImage) {
                throw new common_1.BadRequestException('No hay imagen de perfil para eliminar');
            }
            const publicId = this.cloudinaryService.extractPublicIdFromUrl(user.profileImage);
            if (publicId) {
                await this.cloudinaryService.deleteImage(publicId);
                console.log(`🗑️ Imagen de perfil eliminada de Cloudinary: ${publicId}`);
            }
            const updatedUser = await this.usersService.update(userId, { profileImage: null });
            return this.successResponse('Imagen de perfil eliminada exitosamente', updatedUser);
        }
        catch (error) {
            console.error('❌ Error al eliminar imagen de perfil:', error);
            if (error instanceof common_1.BadRequestException)
                throw error;
            if (error instanceof common_1.NotFoundException)
                throw error;
            throw new common_1.BadRequestException(error.message || 'Error al eliminar la imagen');
        }
    }
};
exports.UsersController = UsersController;
__decorate([
    (0, common_1.Post)('register'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_user_dto_1.CreateUserDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "register", null);
__decorate([
    (0, common_1.Post)('login'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "login", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Get)('me'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "getProfile", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Patch)('me'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [update_user_dto_1.UpdateUserDto, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "updateProfile", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Patch)('me/upload-image'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('profileImage', {
        limits: {
            fileSize: 10 * 1024 * 1024,
        },
        fileFilter: createMulterImageFilter([
            'image/jpeg',
            'image/png',
            'image/webp',
            'image/heic',
        ]),
    })),
    __param(0, (0, common_1.UploadedFile)()),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "uploadProfileImage", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findAllUsers", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Delete)('me'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "deleteMyAccount", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Delete)('me/image'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "deleteProfileImage", null);
exports.UsersController = UsersController = __decorate([
    (0, common_1.Controller)('users'),
    __metadata("design:paramtypes", [users_service_1.UsersService,
        jwt_1.JwtService,
        cloudinary_service_1.CloudinaryService,
        image_compression_service_1.ImageCompressionService])
], UsersController);
//# sourceMappingURL=users.controller.js.map