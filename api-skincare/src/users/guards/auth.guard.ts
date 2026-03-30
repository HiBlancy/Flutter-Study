import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private jwtService: JwtService,
    private usersService: UsersService,
  ) {}

  private extractToken(req: any): string | null {
    return (
      req.headers['authorization']?.replace('Bearer ', '') ||
      req.headers['x-token'] ||
      null
    );
  }

  private async verifyAndGetUser(token: string) {
    if (!token) {
      throw new UnauthorizedException('Token no proporcionado');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token);
      const user = await this.usersService.findById(payload._id);

      if (!user) {
        throw new UnauthorizedException('Usuario no encontrado');
      }

      return user;
    } catch (error) {
      throw new UnauthorizedException('Token inválido');
    }
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = this.extractToken(request);

    if (!token) {
      throw new UnauthorizedException('Token no proporcionado');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token);
      const user = await this.usersService.findById(payload._id);

      if (!user) {
        throw new UnauthorizedException('Usuario no encontrado');
      }

      request.user = user;
      return true;
    } catch {
      throw new UnauthorizedException('Token inválido');
    }
  }
}
