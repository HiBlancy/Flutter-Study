"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MonthlyStatsSchema = void 0;
const mongoose_1 = require("mongoose");
exports.MonthlyStatsSchema = new mongoose_1.Schema({
    userId: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Users',
        required: true,
        index: true,
    },
    year: {
        type: Number,
        min: 2024,
        required: true,
    },
    month: {
        type: Number,
        min: 1,
        max: 12,
        required: true,
    },
    productsUsedCount: { type: Number, required: true, default: 0 },
    archivedAt: { type: Date, default: Date.now },
}, { timestamps: true, strict: false });
exports.MonthlyStatsSchema.index({ userId: 1, year: 1, month: 1 }, { unique: true });
//# sourceMappingURL=monthly-stats.schema.js.map