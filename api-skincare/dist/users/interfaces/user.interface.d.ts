export interface User {
    _id: string;
    name: string;
    email: string;
    password: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
    comparePassword(candidatePassword: string): Promise<boolean>;
}
