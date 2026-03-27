import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtService } from '@nestjs/jwt';
import * as express from 'express';
export declare class UsersController {
    private readonly usersService;
    private readonly jwtService;
    constructor(usersService: UsersService, jwtService: JwtService);
    register(createUserDto: CreateUserDto): Promise<any>;
    login(body: {
        email: string;
        password: string;
    }): Promise<any>;
    getProfile(request: express.Request): Promise<any>;
    findById(id: string): Promise<any>;
    findAllUsers(request: express.Request): Promise<any>;
    update(id: string, updateUserDto: UpdateUserDto, request: express.Request): Promise<any>;
    delete(id: string, request: express.Request): Promise<any>;
    deleteWithoutAuth(id: string): Promise<any>;
}
