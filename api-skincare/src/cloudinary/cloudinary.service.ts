// src/cloudinary/cloudinary.service.ts
import { Injectable } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';

@Injectable()
export class CloudinaryService {
  constructor() {
    // Configurar Cloudinary con variables de entorno
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
  }

  /**
   * Sube un archivo a Cloudinary
   * @param fileBuffer Buffer del archivo
   * @param fileName Nombre original del archivo
   * @param folder Carpeta en Cloudinary (ej: 'user-profiles')
   * @returns URL pública de la imagen
   */
  async uploadImage(
    fileBuffer: Buffer,
    fileName: string,
    folder: string = 'user-profiles',
  ): Promise<string> {
    return new Promise((resolve, reject) => {
      // Crear stream desde el buffer
      const stream = Readable.from(fileBuffer);

      // Configurar opciones de subida
      const uploadStream = cloudinary.uploader.upload_stream(
        {
          folder: folder, // Organizar en carpetas
          public_id: `${Date.now()}_${fileName}`,
          resource_type: 'auto',
          quality: 'auto', // Cloudinary optimiza automáticamente
          fetch_format: 'auto', // Usa el formato más óptimo
          width: 500, // Limitar ancho (redimensión en servidor)
          height: 500, // Limitar alto
          crop: 'fill', // Modo de recorte
          gravity: 'face', // Priorizar el rostro
          dpr: 'auto',
        },
        (error: any, result: any) => {
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
      // Piping del stream
      stream.pipe(uploadStream);
    });
  }

  /**
   * Elimina una imagen de Cloudinary
   * @param publicId ID público de la imagen en Cloudinary
   */
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

  /**
   * Extrae el public_id de una URL de Cloudinary
   * @param url URL de la imagen
   */
  extractPublicIdFromUrl(url: string): string | null {
    try {
      // Regex que captura desde '/upload/' hasta el final sin extensión
      // Soporta URLs con transformaciones como /upload/w_200,h_200/v1234/
      const match = url.match(
        /\/upload\/(?:v\d+\/)?(.+?)\.(jpg|jpeg|png|webp|gif)(?:\?|$)/i,
      );
      if (match && match[1]) {
        return match[1];
      }
      // Fallback al método simple original
      const simpleMatch = url.match(/\/([^\/]+\/[^\/]+)\.[a-z]+$/i);
      return simpleMatch ? simpleMatch[1] : null;
    } catch (error) {
      console.error('❌ Error extrayendo public_id:', error);
      return null;
    }
  }
}
