export declare class CloudinaryService {
    constructor();
    uploadImage(fileBuffer: Buffer, fileName: string, folder: string): Promise<string>;
    deleteImage(publicId: string): Promise<boolean>;
    extractPublicIdFromUrl(url: string): string | null;
}
