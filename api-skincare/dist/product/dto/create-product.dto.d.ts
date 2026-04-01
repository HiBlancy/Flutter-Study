export declare class CreateProductDto {
    name: string;
    brand: string;
    imageUrl?: string;
    barcode?: string;
    categories?: string[];
    notes?: string;
    rating?: number;
    listType?: string;
    expirationDate?: Date | string;
    periodAfterOpening?: string;
}
