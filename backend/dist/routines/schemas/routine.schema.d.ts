import { Schema } from 'mongoose';
export declare const RoutineSchema: Schema<any, import("mongoose").Model<any, any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
    strict: false;
}, {
    name: string;
    userId: import("mongoose").Types.ObjectId;
    time: "morning" | "night";
    daysOfWeek: ("monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday")[];
    products: import("mongoose").Types.DocumentArray<{
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, import("mongoose").Types.Subdocument<import("bson").ObjectId, unknown, {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, {}, {}> & {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }>;
} & import("mongoose").DefaultTimestampProps, import("mongoose").Document<unknown, {}, {
    name: string;
    userId: import("mongoose").Types.ObjectId;
    time: "morning" | "night";
    daysOfWeek: ("monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday")[];
    products: import("mongoose").Types.DocumentArray<{
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, import("mongoose").Types.Subdocument<import("bson").ObjectId, unknown, {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, {}, {}> & {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }>;
} & import("mongoose").DefaultTimestampProps, {
    id: string;
}, Omit<import("mongoose").DefaultSchemaOptions, "timestamps" | "strict"> & {
    timestamps: true;
    strict: false;
}> & Omit<{
    name: string;
    userId: import("mongoose").Types.ObjectId;
    time: "morning" | "night";
    daysOfWeek: ("monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday")[];
    products: import("mongoose").Types.DocumentArray<{
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, import("mongoose").Types.Subdocument<import("bson").ObjectId, unknown, {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, {}, {}> & {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }>;
} & import("mongoose").DefaultTimestampProps & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}, "id"> & {
    id: string;
}, unknown, {
    name: string;
    userId: import("mongoose").Types.ObjectId;
    time: "morning" | "night";
    daysOfWeek: ("monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday")[];
    products: import("mongoose").Types.DocumentArray<{
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, import("mongoose").Types.Subdocument<import("bson").ObjectId, unknown, {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }, {}, {}> & {
        productId: import("mongoose").Types.ObjectId;
        order: number;
    }>;
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    _id: import("mongoose").Types.ObjectId;
} & {
    __v: number;
}>;
