import { Schema } from 'mongoose';
export declare const MonthlyStatsSchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
    strict: false;
}, {
    userId: import("mongoose").Types.ObjectId;
    year: number;
    month: number;
    productsUsedCount: number;
    archivedAt: NativeDate;
} & import("mongoose").DefaultTimestampProps, import("mongoose").Document<unknown, {}, {
    userId: import("mongoose").Types.ObjectId;
    year: number;
    month: number;
    productsUsedCount: number;
    archivedAt: NativeDate;
} & import("mongoose").DefaultTimestampProps, {
    id: string;
}, Omit<import("mongoose").DefaultSchemaOptions, "timestamps" | "strict"> & {
    timestamps: true;
    strict: false;
}> & Omit<{
    userId: import("mongoose").Types.ObjectId;
    year: number;
    month: number;
    productsUsedCount: number;
    archivedAt: NativeDate;
} & import("mongoose").DefaultTimestampProps & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, unknown, {
    userId: import("mongoose").Types.ObjectId;
    year: number;
    month: number;
    productsUsedCount: number;
    archivedAt: NativeDate;
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}>;
