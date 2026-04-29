export interface RoutineProduct {
    productId: string;
    order: number;
}
export interface Routine {
    _id: string;
    userId: string;
    name: string;
    time: 'morning' | 'night';
    daysOfWeek: string[];
    products: RoutineProduct[];
    createdAt: Date;
    updatedAt: Date;
}
