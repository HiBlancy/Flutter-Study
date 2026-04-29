export declare class RoutineProductDto {
    productId?: string;
    order?: number;
}
export declare class UpdateRoutineDto {
    name?: string;
    time?: string;
    daysOfWeek?: string[];
    products?: RoutineProductDto[];
}
