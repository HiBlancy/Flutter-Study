"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RoutineSchema = void 0;
const mongoose_1 = require("mongoose");
exports.RoutineSchema = new mongoose_1.Schema({
    userId: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Users',
        required: true,
        index: true,
    },
    name: {
        type: String,
        required: true,
        trim: true,
        maxlength: 100,
    },
    time: {
        type: String,
        enum: ['morning', 'night'],
        required: true,
    },
    daysOfWeek: {
        type: [String],
        enum: [
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday',
            'sunday',
        ],
        required: true,
        validate: {
            validator: (v) => v.length > 0,
            message: 'Debe seleccionar al menos un día',
        },
    },
    products: [
        {
            productId: {
                type: mongoose_1.Schema.Types.ObjectId,
                ref: 'Product',
                required: true,
            },
            order: {
                type: Number,
                required: true,
            },
        },
    ],
}, { timestamps: true, strict: false });
exports.RoutineSchema.index({ userId: 1, name: 1 }, { sparse: true });
//# sourceMappingURL=routine.schema.js.map