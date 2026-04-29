export interface Product {
  _id: string;
  userId: string;
  name: string;
  brand: string;
  imageUrl?: string;
  barcode?: string;
  categories?: string[];
  notes?: string;
  rating?: number;
  listType: string;
  expirationDate?: Date;
  periodAfterOpening?: string;
  openedDate?: Date;
  isOpened: boolean;
  addedAt: Date;
  updatedAt: Date;
}