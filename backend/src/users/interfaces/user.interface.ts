export interface User {
  _id: string;
  name: string;
  email: string;
  phone: string,
  birthDate: Date;
  profileImage: string;
  password: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;

  comparePassword(candidatePassword: string): Promise<boolean>;
}