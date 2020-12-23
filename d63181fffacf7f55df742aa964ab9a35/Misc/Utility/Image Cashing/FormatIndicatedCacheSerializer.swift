
import Foundation

public struct FormatIndicatedCacheSerializer: CacheSerializer {
    
    public static let png = FormatIndicatedCacheSerializer(imageFormat: .PNG)
    public static let jpeg = FormatIndicatedCacheSerializer(imageFormat: .JPEG)
    public static let gif = FormatIndicatedCacheSerializer(imageFormat: .GIF)
    
    /// The indicated image format.
    private let imageFormat: ImageFormat
    
    public func data(with image: Image, original: Data?) -> Data? {
        
        func imageData(withFormat imageFormat: ImageFormat) -> Data? {
            switch imageFormat {
            case .PNG: return image.kf.pngRepresentation()
            case .JPEG: return image.kf.jpegRepresentation(compressionQuality: 1.0)
            case .GIF: return image.kf.gifRepresentation()
            case .unknown: return nil
            }
        }
        
        // generate data with indicated image format
        if let data = imageData(withFormat: imageFormat) {
            return data
        }
        
        let originalFormat = original?.kf.imageFormat ?? .unknown
        
        // generate data with original image's format
        if originalFormat != imageFormat, let data = imageData(withFormat: originalFormat) {
            return data
        }
        
        return original ?? image.kf.normalized.kf.pngRepresentation()
    }
    
    /// Same implementation as `DefaultCacheSerializer`.
    public func image(with data: Data, options: KingfisherOptionsInfo?) -> Image? {
        let options = options ?? KingfisherEmptyOptionsInfo
        return Kingfisher<Image>.image(
            data: data,
            scale: options.scaleFactor,
            preloadAllAnimationData: options.preloadAllAnimationData,
            onlyFirstFrame: options.onlyLoadFirstFrame)
    }
}
