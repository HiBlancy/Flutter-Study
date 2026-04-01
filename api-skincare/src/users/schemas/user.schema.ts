import { Schema } from 'mongoose';
import * as bcrypt from 'bcrypt';

export const UserSchema = new Schema(
  {
    name: { type: String, required: true, trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: { type: String, required: true },
    isActive: { type: Boolean, default: true },
    phone: { type: String, required: false, trim: true },
    birthDate: { type: Date, required: false },
    profileImage: { type: String, required: false },
  },
  { timestamps: true },
);

// comparación de contraseñas
UserSchema.methods.comparePassword = async function (
  candidatePassword: string,
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};