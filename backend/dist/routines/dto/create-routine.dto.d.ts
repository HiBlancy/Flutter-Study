export declare class RoutineProductDto {
    productId: string;
    order: number;
}
export declare class CreateRoutineDto {
    name: string;
    time: string;
    daysOfWeek: string[];
    products?: string[];
}
