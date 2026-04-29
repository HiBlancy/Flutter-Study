import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users.service';
import { Types } from 'mongoose';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private jwtService: JwtService,
    private usersService: UsersService,
  ) { }

  private extractToken(req: any): string | null {
    return (
      req.headers['authorization']?.replace('Bearer ', '') ||
      req.headers['x-token'] ||
      null
    );
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
  const request = context.switchToHttp().getRequest();
  const token = this.extractToken(request);

  if (!token) {
    throw new UnauthorizedException('Token no proporcionado');
  }

  let payload: any;
  try {
    payload = await this.jwtService.verifyAsync(token);
  } catch {
    throw new UnauthorizedException('Token inválido o expirado');
  }
  if (!payload._id || !Types.ObjectId.isValid(payload._id)) {
  throw new UnauthorizedException('Token malformado');
}

  // Fuera del try-catch para que los errores de Mongoose se vean reales
  const user = await this.usersService.findById(payload._id);

  if (!user) {
    throw new UnauthorizedException('Usuario no encontrado');
  }

  request.user = user;
  return true;
}
}
