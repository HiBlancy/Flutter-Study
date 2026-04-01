// products/products.controller.ts
import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Req,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { MoveProductDto } from './dto/move-product.dto';
import { AuthGuard } from '../users/guards/auth.guard';

@Controller('products')
@UseGuards(AuthGuard)
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  private successResponse(message: string, data: any = null) {
    return { status: true, message, data };
  }

  @Post()
  async create(@Req() req, @Body() createProductDto: CreateProductDto) {
    const product = await this.productService.create(req.user._id, createProductDto);
    return this.successResponse('Producto añadido exitosamente', product);
  }

  @Get()
  async findAll(@Req() req, @Query('listType') listType?: string) {
    const products = await this.productService.findAllByUser(req.user._id, listType);
    return this.successResponse('Productos obtenidos', products);
  }

    @Get('stats/summary')
  async getStats(@Req() req) {
    const stats = await this.productService.getStats(req.user._id);
    return this.successResponse('Estadísticas obtenidas', stats);
  }

  @Get('expired/all')
  async getExpired(@Req() req) {
    const products = await this.productService.getExpiredProducts(req.user._id);
    return this.successResponse('Productos caducados', products);
  }

  @Get('expiring/soon')
  async getExpiringSoon(@Req() req, @Query('days') days?: string) {
    const daysNum = days ? parseInt(days) : 30;
    const products = await this.productService.getExpiringSoon(req.user._id, daysNum);
    return this.successResponse(`Productos que caducan en ${daysNum} días`, products);
  }

  @Get(':id')
  async findOne(@Req() req, @Param('id') id: string) {
    const product = await this.productService.findById(id, req.user._id);
    if (!product) {
      throw new NotFoundException(`Producto ${id} no encontrado`);
    }
    return this.successResponse('Producto obtenido', product);
  }

  @Patch(':id')
  async update(
    @Req() req,
    @Param('id') id: string,
    @Body() updateProductDto: UpdateProductDto,
  ) {
    const product = await this.productService.update(id, req.user._id, updateProductDto);
    return this.successResponse('Producto actualizado', product);
  }

  @Patch(':id/move')
  async moveToList(
    @Req() req,
    @Param('id') id: string,
    @Body() moveProductDto: MoveProductDto,
  ) {
    const product = await this.productService.moveToList(
      id,
      req.user._id,
      moveProductDto.targetList,
    );
    return this.successResponse('Producto movido de lista', product);
  }

  @Delete(':id')
  async delete(@Req() req, @Param('id') id: string) {
    const product = await this.productService.delete(id, req.user._id);
    return this.successResponse('Producto eliminado', product);
  }

  @Patch(':id/open')
  async markAsOpened(@Req() req, @Param('id') id: string) {
    const product = await this.productService.markAsOpened(id, req.user._id);
    return this.successResponse('Producto marcado como abierto', product);
  }

  @Post(':id/calculate-expiration')
  async calculateExpiration(@Req() req, @Param('id') id: string) {
    const product = await this.productService.calculateExpirationFromOpening(id, req.user._id);
    return this.successResponse('Fecha de caducidad calculada', product);
  }
}