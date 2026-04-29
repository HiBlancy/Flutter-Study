import { Injectable } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';

@Injectable()
export class CloudinaryService {
  constructor() {
    // variables de entorno
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
  }

  async uploadImage(
    fileBuffer: Buffer,
    fileName: string,
    folder: string,
  ): Promise<string> {
    return new Promise((resolve, reject) => {
      const stream = Readable.from(fileBuffer);
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          folder: folder,
          public_id: `${Date.now()}_${fileName}`,
          resource_type: 'auto',
          quality: 'auto',
          fetch_format: 'auto',
        },
        (error, result) => {
          if (error) {
            console.error('❌ Error en Cloudinary:', error);
            reject(error);
          } else if (result && result.secure_url) {
            console.log('✅ Imagen subida a Cloudinary:', result.secure_url);
            resolve(result.secure_url);
          } else {
            reject(new Error('No se recibió URL de Cloudinary'));
          }
        },
      );
      stream.pipe(uploadStream);
    });
  }

  // elimina la imagen de cloudinary
  async deleteImage(publicId: string): Promise<boolean> {
    try {
      const result = await cloudinary.uploader.destroy(publicId);
      console.log('✅ Imagen eliminada de Cloudinary:', publicId);
      return result.result === 'ok';
    } catch (error) {
      console.error('❌ Error eliminando imagen:', error);
      return false;
    }
  }

  // extrae la url de la nube para posteriormente borrarla
  extractPublicIdFromUrl(url: string): string | null {
    try {
      // Cloudinary URL pattern: .../upload/v123456/folder/image.jpg
      const match = url.match(/\/upload\/(?:v\d+\/)?(.+?)\.(jpg|jpeg|png|webp|gif|heic)(?:\?|$)/i);
      if (match && match[1]) {
        return match[1]; // Retorna 'products/product_123_456' (sin extensión)
      }

      // Fallback más simple
      const parts = url.split('/upload/');
      if (parts.length < 2) return null;

      const afterUpload = parts[1].split('.')[0];
      const versionRemoved = afterUpload.replace(/^v\d+\//, '');
      return versionRemoved;
    } catch (error) {
      console.error('Error extrayendo public_id:', error);
      return null;
    }
  }
}
