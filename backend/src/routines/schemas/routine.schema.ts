import { Schema } from 'mongoose';

export const RoutineSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
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
        validator: (v: string[]) => v.length > 0,
        message: 'Debe seleccionar al menos un día',
      },
    },
    products: [
      {
        productId: {
          type: Schema.Types.ObjectId,
          ref: 'Product',
          required: true,
        },
        order: {
          type: Number,
          required: true,
        },
      },
    ],
  },
  { timestamps: true, strict: false },
);
//
// // Índice para búsquedas rápidas por usuario
// RoutineSchema.index({ userId: 1 });

// Índice compuesto para evitar rutinas duplicadas por usuario y nombre
RoutineSchema.index({ userId: 1, name: 1 }, { sparse: true });
