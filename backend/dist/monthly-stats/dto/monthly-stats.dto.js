"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CurrentMonthStatsDto = exports.YearlyOverviewDto = exports.MonthlyStatsResponseDto = void 0;
class MonthlyStatsResponseDto {
    year;
    month;
    monthName;
    productsUsedCount;
}
exports.MonthlyStatsResponseDto = MonthlyStatsResponseDto;
class YearlyOverviewDto {
    period;
    data;
    total;
}
exports.YearlyOverviewDto = YearlyOverviewDto;
class CurrentMonthStatsDto {
    year;
    month;
    monthName;
    productsUsedCount;
    status;
}
exports.CurrentMonthStatsDto = CurrentMonthStatsDto;
//# sourceMappingURL=monthly-stats.dto.js.map