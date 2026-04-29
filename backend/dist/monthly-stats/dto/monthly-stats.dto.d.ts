export declare class MonthlyStatsResponseDto {
    year: number;
    month: number;
    monthName: string;
    productsUsedCount: number;
}
export declare class YearlyOverviewDto {
    period: string;
    data: MonthlyStatsResponseDto[];
    total: number;
}
export declare class CurrentMonthStatsDto {
    year: number;
    month: number;
    monthName: string;
    productsUsedCount: number;
    status: string;
}
