import { Schema } from 'mongoose';

export const ProductSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
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
      match: /^\d+\s*[Mm]$/  // Valida formato "12M", "6M", etc.
    },
    openedDate: { type: Date, required: false },
  },
  { timestamps: true }
);

// Índice compuesto para evitar duplicados (mismo producto en misma lista)
ProductSchema.index({ userId: 1, barcode: 1, listType: 1 }, { sparse: true });
ProductSchema.virtual('isExpired').get(function () {
  if (!this.expirationDate) return false;
  return new Date() > this.expirationDate;
});