import { Schema } from 'mongoose';
export declare const UserSchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
    name: string;
    email: string;
    password: string;
    isActive: boolean;
    phone?: string | null | undefined;
    birthDate?: NativeDate | null | undefined;
    profileImage?: string | null | undefined;
} & import("mongoose").DefaultTimestampProps, import("mongoose").Document<unknown, {}, {
    name: string;
    email: string;
    password: string;
    isActive: boolean;
    phone?: string | null | undefined;
    birthDate?: NativeDate | null | undefined;
    profileImage?: string | null | undefined;
} & import("mongoose").DefaultTimestampProps, {
    id: string;
}, Omit<import("mongoose").DefaultSchemaOptions, "timestamps"> & {
    timestamps: true;
}> & Omit<{
    name: string;
    email: string;
    password: string;
    isActive: boolean;
    phone?: string | null | undefined;
    birthDate?: NativeDate | null | undefined;
    profileImage?: string | null | undefined;
} & import("mongoose").DefaultTimestampProps & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, unknown, {
    name: string;
    email: string;
    password: string;
    isActive: boolean;
    phone?: string | null | undefined;
    birthDate?: NativeDate | null | undefined;
    profileImage?: string | null | undefined;
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}>;
