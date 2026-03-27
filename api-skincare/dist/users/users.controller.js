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
exports.UsersController = void 0;
const common_1 = require("@nestjs/common");
const users_service_1 = require("./users.service");
const create_user_dto_1 = require("./dto/create-user.dto");
const update_user_dto_1 = require("./dto/update-user.dto");
const bcrypt = __importStar(require("bcrypt"));
const jwt_1 = require("@nestjs/jwt");
const express = __importStar(require("express"));
let UsersController = class UsersController {
    usersService;
    jwtService;
    constructor(usersService, jwtService) {
        this.usersService = usersService;
        this.jwtService = jwtService;
    }
    async register(createUserDto) {
        try {
            const emailExists = await this.usersService.findOne({
                email: createUserDto.email.toLowerCase(),
            });
            if (emailExists) {
                throw new common_1.ConflictException({
                    status: false,
                    message: 'El email ya está registrado',
                });
            }
            const user = await this.usersService.create({
                ...createUserDto,
                email: createUserDto.email.toLowerCase(),
                password: createUserDto.password,
            });
            const token = await this.jwtService.signAsync({
                _id: user._id,
                email: user.email,
                name: user.name,
            });
            return {
                status: true,
                message: 'Usuario registrado exitosamente',
                data: {
                    user: user,
                    token,
                },
            };
        }
        catch (error) {
            if (error instanceof common_1.ConflictException) {
                throw error;
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al crear el usuario',
            });
        }
    }
    async login(body) {
        try {
            const { email, password } = body;
            const user = await this.usersService.findOne({
                email: email.toLowerCase(),
            });
            if (!user) {
                console.log('❌ Usuario NO encontrado');
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Credenciales incorrectas',
                });
            }
            const isPasswordValid = await bcrypt.compare(password, user.password);
            if (!isPasswordValid) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Credenciales incorrectas',
                });
            }
            const token = await this.jwtService.signAsync({
                _id: user._id,
                email: user.email,
                name: user.name,
            });
            return {
                status: true,
                message: 'Login exitoso',
                data: {
                    user: user,
                    token,
                },
            };
        }
        catch (error) {
            if (error instanceof common_1.UnauthorizedException) {
                throw error;
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error en el login',
            });
        }
    }
    async getProfile(request) {
        try {
            const token = request.headers['authorization']?.replace('Bearer ', '') ||
                request.headers['x-token'];
            if (!token) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token no proporcionado',
                });
            }
            const payload = await this.jwtService.verifyAsync(token);
            if (!payload) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token inválido',
                });
            }
            const user = await this.usersService.findOne({ email: payload.email });
            if (!user) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Usuario no encontrado',
                });
            }
            return {
                status: true,
                message: 'Perfil obtenido exitosamente',
                data: user,
            };
        }
        catch (error) {
            if (error instanceof common_1.UnauthorizedException) {
                throw error;
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al obtener el perfil',
            });
        }
    }
    async findById(id) {
        try {
            const user = await this.usersService.findById(id);
            if (!user) {
                throw new common_1.NotFoundException({
                    status: false,
                    message: `Usuario con ID ${id} no encontrado`,
                });
            }
            return {
                status: true,
                message: 'Usuario encontrado exitosamente',
                data: user,
            };
        }
        catch (error) {
            if (error instanceof common_1.NotFoundException) {
                throw error;
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al obtener el usuario',
            });
        }
    }
    async findAllUsers(request) {
        try {
            const token = request.headers['authorization']?.replace('Bearer ', '') ||
                request.headers['x-token'];
            if (token) {
                try {
                    await this.jwtService.verifyAsync(token);
                }
                catch (e) {
                }
            }
            const users = await this.usersService.getAllUsers();
            return {
                status: true,
                message: 'Usuarios obtenidos exitosamente',
                data: users,
            };
        }
        catch (error) {
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al obtener los usuarios',
            });
        }
    }
    async update(id, updateUserDto, request) {
        try {
            const token = request.headers['authorization']?.replace('Bearer ', '') ||
                request.headers['x-token'];
            if (!token) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token no proporcionado',
                });
            }
            const payload = await this.jwtService.verifyAsync(token);
            if (!payload) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token inválido',
                });
            }
            const user = await this.usersService.findById(id);
            if (!user || user.email !== payload.email) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'No tienes permiso para actualizar este usuario',
                });
            }
            const updatedUser = await this.usersService.update(id, updateUserDto);
            if (!updatedUser) {
                throw new common_1.NotFoundException({
                    status: false,
                    message: `Usuario con ID ${id} no encontrado`,
                });
            }
            return {
                status: true,
                message: 'Usuario actualizado exitosamente',
                data: updatedUser,
            };
        }
        catch (error) {
            if (error instanceof common_1.NotFoundException ||
                error instanceof common_1.UnauthorizedException) {
                throw error;
            }
            if (error instanceof common_1.ConflictException) {
                throw new common_1.ConflictException({
                    status: false,
                    message: error.message,
                });
            }
            throw new common_1.BadRequestException({
                status: false,
                message: error.message || 'Error al actualizar el usuario',
            });
        }
    }
    async delete(id, request) {
        try {
            const token = request.headers['authorization']?.replace('Bearer ', '') ||
                request.headers['x-token'];
            if (!token) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token no proporcionado',
                });
            }
            const payload = await this.jwtService.verifyAsync(token);
            if (!payload) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'Token inválido',
                });
            }
            const user = await this.usersService.findById(id);
            if (!user || user.email !== payload.email) {
                throw new common_1.UnauthorizedException({
                    status: false,
                    message: 'No tienes permiso para eliminar este usuario',
                });
            }
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
    (0, common_1.Get)('me'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "getProfile", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findById", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findAllUsers", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_user_dto_1.UpdateUserDto, Object]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "update", null);
__decorate([
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