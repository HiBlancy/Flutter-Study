export interface MonthlyStats{
  userId: string;
  year: number;
  month: number; // 1-12
  productsUsedCount: number;
  archivedAt: Date;
  createdAt: Date;
  updatedAt: Date;
}
