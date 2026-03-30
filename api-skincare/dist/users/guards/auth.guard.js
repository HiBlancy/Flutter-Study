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
exports.AuthGuard = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const users_service_1 = require("../users.service");
let AuthGuard = class AuthGuard {
    jwtService;
    usersService;
    constructor(jwtService, usersService) {
        this.jwtService = jwtService;
        this.usersService = usersService;
    }
    extractToken(req) {
        return (req.headers['authorization']?.replace('Bearer ', '') ||
            req.headers['x-token'] ||
            null);
    }
    async verifyAndGetUser(token) {
        if (!token) {
            throw new common_1.UnauthorizedException('Token no proporcionado');
        }
        try {
            const payload = await this.jwtService.verifyAsync(token);
            const user = await this.usersService.findById(payload._id);
            if (!user) {
                throw new common_1.UnauthorizedException('Usuario no encontrado');
            }
            return user;
        }
        catch (error) {
            throw new common_1.UnauthorizedException('Token inválido');
        }
    }
    async canActivate(context) {
        const request = context.switchToHttp().getRequest();
        const token = this.extractToken(request);
        if (!token) {
            throw new common_1.UnauthorizedException('Token no proporcionado');
        }
        try {
            const payload = await this.jwtService.verifyAsync(token);
            const user = await this.usersService.findById(payload._id);
            if (!user) {
                throw new common_1.UnauthorizedException('Usuario no encontrado');
            }
            request.user = user;
            return true;
        }
        catch {
            throw new common_1.UnauthorizedException('Token inválido');
        }
    }
};
exports.AuthGuard = AuthGuard;
exports.AuthGuard = AuthGuard = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [jwt_1.JwtService,
        users_service_1.UsersService])
], AuthGuard);
//# sourceMappingURL=auth.guard.js.map