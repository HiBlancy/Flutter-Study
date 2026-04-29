export declare class ImageCompressionService {
    compressProfileImage(buffer: Buffer, originalMime: string): Promise<Buffer>;
    compressProductImage(buffer: Buffer, originalMime: string): Promise<Buffer>;
}
