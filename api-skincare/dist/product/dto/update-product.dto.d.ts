export declare class UpdateProductDto {
    name?: string;
    brand?: string | null;
    imageUrl?: string | null;
    barcode?: string | null;
    categories?: string[] | null;
    notes?: string | null;
    rating?: number | null;
    listType?: string;
    expirationDate?: Date | string;
    periodAfterOpening?: string;
    openedDate?: Date | string | null;
    isOpened?: boolean | null;
}
