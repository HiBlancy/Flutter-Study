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
const users_service_1 = require("./users.service");
const create_user_dto_1 = require("./dto/create-user.dto");
const update_user_dto_1 = require("./dto/update-user.dto");
const jwt_1 = require("@nestjs/jwt");
const auth_guard_1 = require("./guards/auth.guard");
let UsersController = class UsersController {
    usersService;
    jwtService;
    constructor(usersService, jwtService) {
        this.usersService = usersService;
        this.jwtService = jwtService;
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
    async findById(id) {
        const user = await this.usersService.findById(id);
        if (!user)
            throw new common_1.NotFoundException(`Usuario ${id} no encontrado`);
        return this.successResponse('Usuario encontrado', user);
    }
    async findAllUsers() {
        const users = await this.usersService.getAllUsers();
        return this.successResponse('Usuarios obtenidos', users);
    }
    async update(id, updateUserDto, req) {
        if (req.user._id !== id) {
            throw new common_1.UnauthorizedException('No puedes actualizar otro usuario');
        }
        const updatedUser = await this.usersService.update(id, updateUserDto);
        return this.successResponse('Usuario actualizado', updatedUser);
    }
    async delete(id, req) {
        if (req.user._id !== id) {
            throw new common_1.UnauthorizedException('No puedes eliminar otro usuario');
        }
        const deletedUser = await this.usersService.delete(id);
        return this.successResponse('Usuario eliminado', deletedUser);
    }
    async deleteWithoutAuth(id) {
        try {
            const deletedUser = await this.usersService.delete(id);
            if (!deletedUser) {
                throw new common_1.NotFoundException({
                    status: false,
                    message: `Usuario con ID ${id} no encontrado`,
                });
            }
            return {
                status: true,
                message: 'Usuario eliminado exitosamente',
                data: deletedUser,
            };
        }
        catch (error) {
            if (error instanceof common_1.NotFoundException) {
                throw error;
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al eliminar el usuario',
            });
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
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findById", null);
__decorate([
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findAllUsers", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_user_dto_1.UpdateUserDto, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "update", null);
__decorate([
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "delete", null);
__decorate([
    (0, common_1.Delete)('delete/:id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "deleteWithoutAuth", null);
exports.UsersController = UsersController = __decorate([
    (0, common_1.Controller)('users'),
    __metadata("design:paramtypes", [users_service_1.UsersService,
        jwt_1.JwtService])
], UsersController);
//# sourceMappingURL=users.controller.js.map