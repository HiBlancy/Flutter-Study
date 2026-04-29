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
  UseInterceptors,
  UploadedFile, NotFoundException,
} from '@nestjs/common';
import { ProductService } from './product.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { MoveProductDto } from './dto/move-product.dto';
import { AuthGuard } from '../users/guards/auth.guard';
import { PaginationDto } from '../pagination/pagination.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { CleanupService } from '../monthly-stats/services/cleanup.service';
import { multerImageFilter } from '../common/multer.utils';

@Controller('products')
@UseGuards(AuthGuard)
export class ProductController {
  constructor(
    private readonly productService: ProductService,
    private readonly cleanupService: CleanupService,
  ) {}

  // respuesta 200 / 201
  private successResponse(message: string, data: any = null) {
    return { status: true, message, data };
  }

  // crear producto
  @Post()
  async create(@Req() req, @Body() createProductDto: CreateProductDto) {
    const product = await this.productService.create(
      req.user._id,
      createProductDto,
    );
    return this.successResponse('Producto añadido exitosamente', product);
  }

  // obtener todos los productos paginados
  @Get()
  async findAll(
    @Req() req,
    @Query() paginationDto: PaginationDto,
    @Query('listType') listType?: string,
  ) {
    const result = await this.productService.findAllByUserPaginated(
      req.user._id,
      paginationDto,
      listType,
    );
    return this.successResponse('Productos obtenidos con paginación', result);
  }

  // obtener la cantidad de productos segun la lista que estan
  @Get('stats/summary')
  async getStats(@Req() req) {
    const stats = await this.productService.getStats(req.user._id);
    return this.successResponse('Estadísticas obtenidas', stats);
  }

  // obtener todos los productos caducados
  @Get('expired/all')
  async getExpired(@Req() req) {
    const products = await this.productService.getExpiredProducts(req.user._id);
    return this.successResponse('Productos caducados', {
      count: products.length,
      products,
    });
  }

  // obtener productos que caducan pronto
  @Get('expiring/soon')
  async getExpiringSoon(@Req() req, @Query('days') days?: string) {
    const daysNum = days ? parseInt(days, 10) : 30;
    const products = await this.productService.getExpiringSoon(
      req.user._id,
      daysNum,
    );
    return this.successResponse(`Productos que caducan en ${daysNum} días`, {
      count: products.length,
      products,
    });
  }

  // obtener producto segun su id
  @Get(':id')
  async findOne(@Req() req, @Param('id') id: string) {
    const product = await this.productService.findById(id, req.user._id);
    if (!product) {
      throw new NotFoundException(`Producto ${id} no encontrado`);
    }
    return this.successResponse('Producto obtenido', product);
  }

  // actualizar parcialmente un producto
  @Patch(':id')
  async update(
    @Req() req,
    @Param('id') id: string,
    @Body() updateProductDto: UpdateProductDto,
  ) {
    const product = await this.productService.update(
      id,
      req.user._id,
      updateProductDto,
    );
    return this.successResponse('Producto actualizado', product);
  }

  // mover el producto en otra lista
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

  // eliminar producto
  @Delete(':id')
  async delete(@Req() req, @Param('id') id: string) {
    const product = await this.productService.delete(id, req.user._id);
    return this.successResponse('Producto eliminado', product);
  }

  // marcar el producto como abierto
  @Patch(':id/open')
  async markAsOpened(
    @Req() req,
    @Param('id') id: string,
    @Body('openedDate') openedDateStr?: string,
  ) {
    const customDate = openedDateStr ? new Date(openedDateStr) : undefined;
    const product = await this.productService.markAsOpened(
      id,
      req.user._id,
      customDate,
    );
    return this.successResponse('Producto marcado como abierto', product);
  }

  // cerrar el producto
  @Patch(':id/close')
  async markAsClosed(@Req() req, @Param('id') id: string) {
    const product = await this.productService.markAsClosed(id, req.user._id);
    return this.successResponse('Producto marcado como cerrado', product);
  }

  // calcular la fecha de vencimiento de producto una vez abierto
  @Post(':id/calculate-expiration')
  async calculateExpiration(@Req() req, @Param('id') id: string) {
    const product = await this.productService.calculateExpirationFromOpening(
      id,
      req.user._id,
    );
    return this.successResponse('Fecha de caducidad calculada', product);
  }

  // subir imagen al producto
  @Post(':id/upload-image')
  @UseInterceptors(
    FileInterceptor('productImage', {
      limits: { fileSize: 10 * 1024 * 1024 },
      fileFilter: multerImageFilter(['image/jpeg', 'image/png', 'image/webp']),
    }),
  )
  async uploadProductImage(
    @Param('id') productId: string,
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ) {
    if (!file) {
      throw new BadRequestException('No se proporcionó ningún archivo');
    }

    const updatedProduct = await this.productService.updateProductImage(
      productId,
      req.user._id,
      file.buffer,
      file.mimetype,
    );

    return this.successResponse('Imagen de producto actualizada exitosamente', updatedProduct);
  }

  // eliminar foto del producto
  @Delete(':id/image')
  async deleteProductImage(@Param('id') productId: string, @Req() req) {
    const updated = await this.productService.deleteProductImage(
      productId,
      req.user._id,
    );
    return this.successResponse('Imagen de producto eliminada', updated);
  }

  // historial de los productos usados segun mes
  @Get('stats/monthly-history')
  async getMonthlyHistory(@Req() req) {
    const stats = await this.productService.getMonthlyHistory(req.user._id);
    return this.successResponse('Historial mensual obtenido', stats);
  }

  // historial de los productos usados a lo largo del anio
  @Get('stats/yearly-overview')
  async getYearlyOverview(@Req() req) {
    const stats = await this.productService.getYearlyOverview(req.user._id);
    return this.successResponse('Vista anual obtenida', stats);
  }

  // historial del mes actual
  @Get('stats/current-month')
  async getCurrentMonthStats(@Req() req) {
    const stats = await this.productService.getCurrentMonthStats(req.user._id);
    return this.successResponse('Estadísticas del mes actual', stats);
  }

  // endpoint de pruebas (mes actual)
  @Post('cleanup/test')
  async triggerTestCleanup(@Req() req) {
    const result = await this.cleanupService.testCleanupNow();
    return this.successResponse(result.message, result);
  }

  // llamada de prueba para hacer limpieza sin tener que ser fin de mes
  @Post('cleanup/execute')
  async triggerCleanup(@Req() req) {
    const result = await this.cleanupService.cleanupUsedProducts();
    return this.successResponse('Limpieza ejecutada (mes anterior)');
  }
}