import { Schema } from 'mongoose';

export const ProductSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'Users',
      required: true,
      index: true,
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
      required: false,
    },
    listType: {
      type: String,
      enum: ['wishlist', 'have', 'used'],
      default: 'have',
    },
    expirationDate: { type: Date, match: /^\d{4}-\d{2}-\d{2}$/ },
    periodAfterOpening: {
      type: String,
      required: false,
      match: /^\d+\s*[Mm]$/,
    },
    openedDate: { type: Date, required: false },
    isOpened: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true, strict: false },
);

// Índice compuesto para evitar duplicados (mismo producto en misma lista)
ProductSchema.index({ userId: 1, barcode: 1, listType: 1 }, { sparse: true });
ProductSchema.virtual('isExpired').get(function () {
  if (!this.expirationDate) return false;
  const expDate = new Date(this.expirationDate); // convierte "2025-12-25" a Date UTC
  const today = new Date();
  today.setHours(0, 0, 0, 0); // normalizar a medianoche UTC
  return today > expDate;
});