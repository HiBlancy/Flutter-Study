export class MonthlyStatsResponseDto {
  year: number;
  month: number;
  monthName: string;
  productsUsedCount: number;
}

export class YearlyOverviewDto {
  period: string; // '12_months'
  data: MonthlyStatsResponseDto[];
  total: number; // suma total de productos en los 12 meses
}

export class CurrentMonthStatsDto {
  year: number;
  month: number;
  monthName: string;
  productsUsedCount: number;
  status: string; // 'current'
}
