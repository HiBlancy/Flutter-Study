import { Schema } from 'mongoose';
export declare const ProductSchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
    strict: false;
}, {
    name: string;
    brand: string;
    categories: string[];
    listType: "wishlist" | "have" | "used";
    isOpened: boolean;
    userId: import("mongoose").Types.ObjectId;
    imageUrl?: string | null | undefined;
    barcode?: string | null | undefined;
    notes?: string | null | undefined;
    rating?: number | null | undefined;
    expirationDate?: NativeDate | null | undefined;
    periodAfterOpening?: string | null | undefined;
    openedDate?: NativeDate | null | undefined;
} & import("mongoose").DefaultTimestampProps, import("mongoose").Document<unknown, {}, {
    name: string;
    brand: string;
    categories: string[];
    listType: "wishlist" | "have" | "used";
    isOpened: boolean;
    userId: import("mongoose").Types.ObjectId;
    imageUrl?: string | null | undefined;
    barcode?: string | null | undefined;
    notes?: string | null | undefined;
    rating?: number | null | undefined;
    expirationDate?: NativeDate | null | undefined;
    periodAfterOpening?: string | null | undefined;
    openedDate?: NativeDate | null | undefined;
} & import("mongoose").DefaultTimestampProps, {
    id: string;
}, Omit<import("mongoose").DefaultSchemaOptions, "timestamps" | "strict"> & {
    timestamps: true;
    strict: false;
}> & Omit<{
    name: string;
    brand: string;
    categories: string[];
    listType: "wishlist" | "have" | "used";
    isOpened: boolean;
    userId: import("mongoose").Types.ObjectId;
    imageUrl?: string | null | undefined;
    barcode?: string | null | undefined;
    notes?: string | null | undefined;
    rating?: number | null | undefined;
    expirationDate?: NativeDate | null | undefined;
    periodAfterOpening?: string | null | undefined;
    openedDate?: NativeDate | null | undefined;
} & import("mongoose").DefaultTimestampProps & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, unknown, {
    name: string;
    brand: string;
    categories: string[];
    listType: "wishlist" | "have" | "used";
    isOpened: boolean;
    userId: import("mongoose").Types.ObjectId;
    imageUrl?: string | null | undefined;
    barcode?: string | null | undefined;
    notes?: string | null | undefined;
    rating?: number | null | undefined;
    expirationDate?: NativeDate | null | undefined;
    periodAfterOpening?: string | null | undefined;
    openedDate?: NativeDate | null | undefined;
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}>;
