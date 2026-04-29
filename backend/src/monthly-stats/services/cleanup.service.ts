import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Cron } from '@nestjs/schedule';
import { CloudinaryService } from '../../cloudinary/cloudinary.service';
import { Product } from '../../product/interfaces/product.interface';
import { ProductService } from '../../product/product.service';

@Injectable()
export class CleanupService {
  private readonly logger = new Logger(CleanupService.name);

  constructor(
    @InjectModel('Product') private readonly productModel: Model<Product>,
    private readonly productService: ProductService,
    private readonly cloudinaryService: CloudinaryService,
  ) {}

  // CRON: se ejecuta el primer día del mes a las 00:00
  // Guarda los productos usados del MES ANTERIOR y los elimina
  @Cron('0 0 1 * *')
  async cleanupUsedProducts(): Promise<void> {
    this.logger.log('🧹 [CRON] Iniciando limpieza mensual de productos usados');
    await this.executeCleanup(false); // false = mes anterior
  }

  // Método para pruebas: guarda los productos usados del MES ACTUAL y los elimina
  async testCleanupNow(): Promise<{ success: boolean; message: string }> {
    try {
      this.logger.log('🧪 [TEST] Ejecutando limpieza de pruebas (mes actual)');
      await this.executeCleanup(true); // true = mes actual
      return {
        success: true,
        message: 'Limpieza de pruebas ejecutada exitosamente',
      };
    } catch (error) {
      this.logger.error(`❌ Error en limpieza de pruebas: ${error.message}`);
      return { success: false, message: `Error: ${error.message}` };
    }
  }

  // Lógica común para la limpieza
  private async executeCleanup(useCurrentMonth: boolean): Promise<void> {
    try {
      const now = new Date();
      let year: number;
      let month: number; // 1-12

      if (useCurrentMonth) {
        year = now.getFullYear();
        month = now.getMonth() + 1;
        this.logger.log(
          `Archivando productos para el mes actual: ${month}/${year}`,
        );
      } else {
        // Mes anterior
        if (now.getMonth() === 0) {
          year = now.getFullYear() - 1;
          month = 12;
        } else {
          year = now.getFullYear();
          month = now.getMonth();
        }
        this.logger.log(
          `Archivando productos para el mes anterior: ${month}/${year}`,
        );
      }

      const usersWithUsed = await this.productModel.aggregate([
        { $match: { listType: 'used' } },
        {
          $group: {
            _id: '$userId',
            productIds: { $push: '$_id' },
            imageUrls: { $push: '$imageUrl' },
          },
        },
      ]);

      if (usersWithUsed.length === 0) {
        this.logger.log('No hay productos usados para limpiar');
        return;
      }

      for (const userData of usersWithUsed) {
        const userId = userData._id.toString();
        const count = userData.productIds.length;
        const imageUrls = userData.imageUrls.filter(
          (url: string | null) => url != null,
        );

        await this.productService.updateOrCreateMonthlyStats(
          userId,
          year,
          month,
          count,
        );

        for (const url of imageUrls) {
          const publicId = this.cloudinaryService.extractPublicIdFromUrl(url);
          if (publicId) {
            try {
              await this.cloudinaryService.deleteImage(publicId);
              this.logger.debug(`Imagen eliminada: ${publicId}`);
            } catch (err: any) {
              this.logger.warn(
                `Error eliminando imagen ${publicId}: ${err.message}`,
              );
            }
          }
        }

        await this.productModel.deleteMany({
          _id: { $in: userData.productIds },
        });
        this.logger.log(
          `Usuario ${userId}: ${count} productos usados archivados (${month}/${year})`,
        );
      }

      this.logger.log('✅ Limpieza completada');
    } catch (error) {
      this.logger.error(`❌ Error en limpieza: ${error.message}`, error.stack);
      throw error; // Para que el método de pruebas pueda capturarlo
    }
  }
}
