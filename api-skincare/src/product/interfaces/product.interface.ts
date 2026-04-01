export interface Product {
  _id: string;
  userId: string;           // Relación con usuario
  name: string;             // Obligatorio
  brand: string;            // Obligatorio
  imageUrl?: string;        // Opcional
  barcode?: string;         // Para escanear
  categories?: string[];    // Para futuros filtros
  notes?: string;           // Notas personales
  rating?: number;          // 1-5 estrellas
  listType: string;  // Lista principal donde está el producto
  expirationDate?: Date;  // Fecha específica de caducidad
  periodAfterOpening?: string;  // Ej: "12M" (12 meses después de abrir)
  openedDate?: Date;  // Fecha de apertura (para calcular caducidad)
  addedAt: Date;            // Cuándo lo añadió
  updatedAt: Date;
}
//tema de caducidad sea fecha o potecito M del producto