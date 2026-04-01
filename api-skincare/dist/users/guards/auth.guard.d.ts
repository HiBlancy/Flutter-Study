import { CanActivate, ExecutionContext } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users.service';
export declare class AuthGuard implements CanActivate {
    private jwtService;
    private usersService;
    constructor(jwtService: JwtService, usersService: UsersService);
    private extractToken;
    canActivate(context: ExecutionContext): Promise<boolean>;
}
