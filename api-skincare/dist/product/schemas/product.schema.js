"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductSchema = void 0;
const mongoose_1 = require("mongoose");
exports.ProductSchema = new mongoose_1.Schema({
    userId: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Users',
        required: true,
        index: true
    },
    name: { type: String, required: true, trim: true },
    brand: { type: String, required: true, trim: true },
    imageUrl: { type: String, required: false },
    barcode: { type: String, required: false, sparse: true, index: true },
    categories: [{ type: String, trim: true }],
    notes: { type: String, required: false },
    rating: {
        type: Number,
        min: 1,
        max: 5,
        required: false
    },
    listType: {
        type: String,
        enum: ['wishlist', 'favorites', 'have', 'used', 'deleted'],
        default: 'have'
    },
    expirationDate: { type: Date, required: false },
    periodAfterOpening: {
        type: String,
        required: false,
        match: /^\d+\s*[Mm]$/
    },
    openedDate: { type: Date, required: false },
}, { timestamps: true });
exports.ProductSchema.index({ userId: 1, barcode: 1, listType: 1 }, { sparse: true });
exports.ProductSchema.virtual('isExpired').get(function () {
    if (!this.expirationDate)
        return false;
    return new Date() > this.expirationDate;
});
//# sourceMappingURL=product.schema.js.map