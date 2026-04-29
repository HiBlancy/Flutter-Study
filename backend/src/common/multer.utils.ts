import { BadRequestException } from '@nestjs/common';

export function multerImageFilter(allowedMimes: string[]) {
  return (req: any, file: Express.Multer.File, cb: any) => {
    if (!allowedMimes.includes(file.mimetype)) {
      cb(
        new BadRequestException(
          `Tipo de archivo no permitido. Permitidos: ${allowedMimes.join(', ')}`,
        ),
        false,
      );
    } else {
      cb(null, true);
    }
  };
}