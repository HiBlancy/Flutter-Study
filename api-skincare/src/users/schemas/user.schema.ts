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
  },
  { timestamps: true },
);

//comparacion de contrasenas
UserSchema.methods.comparePassword = async function (
  candidatePassword: string,
): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};