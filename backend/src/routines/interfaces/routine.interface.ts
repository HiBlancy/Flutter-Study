export interface RoutineProduct {
  productId: string; // Referencia al producto
  order: number; // Posición en la rutina (0, 1, 2, ...)
}

export interface Routine {
  _id: string;
  userId: string; // Referencia al usuario propietario
  name: string; // Nombre de la rutina
  time: 'morning' | 'night'; // Mañana o noche
  daysOfWeek: string[]; // ['monday', 'tuesday', ...] (días de la semana)
  products: RoutineProduct[]; // Array de productos en orden
  createdAt: Date;
  updatedAt: Date;
}
