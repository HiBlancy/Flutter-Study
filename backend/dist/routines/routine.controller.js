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
exports.RoutineController = void 0;
const common_1 = require("@nestjs/common");
const routine_service_1 = require("./routine.service");
const create_routine_dto_1 = require("./dto/create-routine.dto");
const update_routine_dto_1 = require("./dto/update-routine.dto");
const reorder_products_dto_1 = require("./dto/reorder-products.dto");
const auth_guard_1 = require("../users/guards/auth.guard");
let RoutineController = class RoutineController {
    routineService;
    constructor(routineService) {
        this.routineService = routineService;
    }
    successResponse(message, data = null) {
        return { status: true, message, data };
    }
    async create(req, createRoutineDto) {
        const routine = await this.routineService.create(req.user._id, createRoutineDto);
        return this.successResponse('Rutina creada exitosamente', routine);
    }
    async findAll(req) {
        const routines = await this.routineService.findAllByUser(req.user._id);
        return this.successResponse('Rutinas obtenidas', {
            data: routines,
            total: routines.length,
        });
    }
    async findOne(req, id) {
        const routine = await this.routineService.findById(id, req.user._id);
        if (!routine) {
            throw new common_1.NotFoundException(`Rutina ${id} no encontrada`);
        }
        return this.successResponse('Rutina obtenida', routine);
    }
    async update(req, id, updateRoutineDto) {
        const routine = await this.routineService.update(id, req.user._id, updateRoutineDto);
        return this.successResponse('Rutina actualizada exitosamente', routine);
    }
    async delete(req, id) {
        const routine = await this.routineService.delete(id, req.user._id);
        return this.successResponse('Rutina eliminada exitosamente', routine);
    }
    async reorderProducts(req, id, reorderDto) {
        const routine = await this.routineService.reorderProducts(id, req.user._id, reorderDto);
        return this.successResponse('Productos reordenados exitosamente', routine);
    }
    async addProduct(req, id, productId) {
        const routine = await this.routineService.addProduct(id, req.user._id, productId);
        return this.successResponse('Producto agregado a la rutina', routine);
    }
    async removeProduct(req, id, productId) {
        const routine = await this.routineService.removeProduct(id, req.user._id, productId);
        return this.successResponse('Producto eliminado de la rutina', routine);
    }
};
exports.RoutineController = RoutineController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, create_routine_dto_1.CreateRoutineDto]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "findOne", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, update_routine_dto_1.UpdateRoutineDto]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "update", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "delete", null);
__decorate([
    (0, common_1.Patch)(':id/reorder'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, reorder_products_dto_1.ReorderProductsDto]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "reorderProducts", null);
__decorate([
    (0, common_1.Post)(':id/products'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)('productId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "addProduct", null);
__decorate([
    (0, common_1.Delete)(':id/products/:productId'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Param)('productId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String, String]),
    __metadata("design:returntype", Promise)
], RoutineController.prototype, "removeProduct", null);
exports.RoutineController = RoutineController = __decorate([
    (0, common_1.Controller)('routines'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    __metadata("design:paramtypes", [routine_service_1.RoutineService])
], RoutineController);
//# sourceMappingURL=routine.controller.js.map