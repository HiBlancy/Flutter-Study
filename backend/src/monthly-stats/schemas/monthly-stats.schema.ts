import { Schema } from 'mongoose';

export const MonthlyStatsSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
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
  },
  { timestamps: true, strict: false },
);

// Índice compuesto para evitar duplicados y búsquedas rápidas
MonthlyStatsSchema.index({ userId: 1, year: 1, month: 1 }, { unique: true });
