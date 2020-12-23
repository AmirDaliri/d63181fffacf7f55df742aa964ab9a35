
#if os(macOS)
import AppKit
#else
import UIKit
#endif
    
public typealias KingfisherOptionsInfo = [KingfisherOptionsInfoItem]
let KingfisherEmptyOptionsInfo = [KingfisherOptionsInfoItem]()

public enum KingfisherOptionsInfoItem {

    case targetCache(ImageCache)
    
    case originalCache(ImageCache)
    
    case downloader(ImageDownloader)
    
    case transition(ImageTransition)
    
    case downloadPriority(Float)
    
    case forceRefresh

    case fromMemoryCacheOrRefresh

    case forceTransition
    
    case cacheMemoryOnly
    
    case waitForCache
    
    case onlyFromCache
    
    case backgroundDecode
    
    case callbackDispatchQueue(DispatchQueue?)

    case scaleFactor(CGFloat)

    case preloadAllAnimationData
    
    case requestModifier(ImageDownloadRequestModifier)
    
    case processor(ImageProcessor)
    
    case cacheSerializer(CacheSerializer)

    case imageModifier(ImageModifier)
    
    case keepCurrentImageWhileLoading

    case onlyLoadFirstFrame
    
    case cacheOriginalImage
}

precedencegroup ItemComparisonPrecedence {
    associativity: none
    higherThan: LogicalConjunctionPrecedence
}

infix operator <== : ItemComparisonPrecedence

// This operator returns true if two `KingfisherOptionsInfoItem` enum is the same, without considering the associated values.
func <== (lhs: KingfisherOptionsInfoItem, rhs: KingfisherOptionsInfoItem) -> Bool {
    switch (lhs, rhs) {
    case (.targetCache(_), .targetCache(_)): return true
    case (.originalCache(_), .originalCache(_)): return true
    case (.downloader(_), .downloader(_)): return true
    case (.transition(_), .transition(_)): return true
    case (.downloadPriority(_), .downloadPriority(_)): return true
    case (.forceRefresh, .forceRefresh): return true
    case (.fromMemoryCacheOrRefresh, .fromMemoryCacheOrRefresh): return true
    case (.forceTransition, .forceTransition): return true
    case (.cacheMemoryOnly, .cacheMemoryOnly): return true
    case (.waitForCache, .waitForCache): return true
    case (.onlyFromCache, .onlyFromCache): return true
    case (.backgroundDecode, .backgroundDecode): return true
    case (.callbackDispatchQueue(_), .callbackDispatchQueue(_)): return true
    case (.scaleFactor(_), .scaleFactor(_)): return true
    case (.preloadAllAnimationData, .preloadAllAnimationData): return true
    case (.requestModifier(_), .requestModifier(_)): return true
    case (.processor(_), .processor(_)): return true
    case (.cacheSerializer(_), .cacheSerializer(_)): return true
    case (.imageModifier(_), .imageModifier(_)): return true
    case (.keepCurrentImageWhileLoading, .keepCurrentImageWhileLoading): return true
    case (.onlyLoadFirstFrame, .onlyLoadFirstFrame): return true
    case (.cacheOriginalImage, .cacheOriginalImage): return true
    default: return false
    }
}


extension Collection where Iterator.Element == KingfisherOptionsInfoItem {
    func lastMatchIgnoringAssociatedValue(_ target: Iterator.Element) -> Iterator.Element? {
        return reversed().first { $0 <== target }
    }
    
    func removeAllMatchesIgnoringAssociatedValue(_ target: Iterator.Element) -> [Iterator.Element] {
        return filter { !($0 <== target) }
    }
}

extension Collection where Iterator.Element == KingfisherOptionsInfoItem {
    /// The target `ImageCache` which is used.
    public var targetCache: ImageCache? {
        if let item = lastMatchIgnoringAssociatedValue(.targetCache(.default)),
            case .targetCache(let cache) = item
        {
            return cache
        }
        return nil
    }
    
    /// The original `ImageCache` which is used.
    public var originalCache: ImageCache? {
        if let item = lastMatchIgnoringAssociatedValue(.originalCache(.default)),
            case .originalCache(let cache) = item
        {
            return cache
        }
        return targetCache
    }
    
    /// The `ImageDownloader` which is specified.
    public var downloader: ImageDownloader? {
        if let item = lastMatchIgnoringAssociatedValue(.downloader(.default)),
            case .downloader(let downloader) = item
        {
            return downloader
        }
        return nil
    }
    
    /// Member for animation transition when using UIImageView.
    public var transition: ImageTransition {
        if let item = lastMatchIgnoringAssociatedValue(.transition(.none)),
            case .transition(let transition) = item
        {
            return transition
        }
        return ImageTransition.none
    }
    
    /// A `Float` value set as the priority of image download task. The value for it should be
    /// between 0.0~1.0.
    public var downloadPriority: Float {
        if let item = lastMatchIgnoringAssociatedValue(.downloadPriority(0)),
            case .downloadPriority(let priority) = item
        {
            return priority
        }
        return URLSessionTask.defaultPriority
    }
    
    /// Whether an image will be always downloaded again or not.
    public var forceRefresh: Bool {
        return contains{ $0 <== .forceRefresh }
    }

    /// Whether an image should be got only from memory cache or download.
    public var fromMemoryCacheOrRefresh: Bool {
        return contains{ $0 <== .fromMemoryCacheOrRefresh }
    }
    
    /// Whether the transition should always happen or not.
    public var forceTransition: Bool {
        return contains{ $0 <== .forceTransition }
    }
    
    /// Whether cache the image only in memory or not.
    public var cacheMemoryOnly: Bool {
        return contains{ $0 <== .cacheMemoryOnly }
    }
    
    /// Whether the caching operation will be waited or not.
    public var waitForCache: Bool {
        return contains{ $0 <== .waitForCache }
    }
    
    /// Whether only load the images from cache or not.
    public var onlyFromCache: Bool {
        return contains{ $0 <== .onlyFromCache }
    }
    
    /// Whether the image should be decoded in background or not.
    public var backgroundDecode: Bool {
        return contains{ $0 <== .backgroundDecode }
    }

    /// Whether the image data should be all loaded at once if it is an animated image.
    public var preloadAllAnimationData: Bool {
        return contains { $0 <== .preloadAllAnimationData }
    }
    
    /// The queue of callbacks should happen from Kingfisher.
    public var callbackDispatchQueue: DispatchQueue {
        if let item = lastMatchIgnoringAssociatedValue(.callbackDispatchQueue(nil)),
            case .callbackDispatchQueue(let queue) = item
        {
            return queue ?? DispatchQueue.main
        }
        return DispatchQueue.main
    }
    
    /// The scale factor which should be used for the image.
    public var scaleFactor: CGFloat {
        if let item = lastMatchIgnoringAssociatedValue(.scaleFactor(0)),
            case .scaleFactor(let scale) = item
        {
            return scale
        }
        return 1.0
    }
    
    /// The `ImageDownloadRequestModifier` will be used before sending a download request.
    public var modifier: ImageDownloadRequestModifier {
        if let item = lastMatchIgnoringAssociatedValue(.requestModifier(NoModifier.default)),
            case .requestModifier(let modifier) = item
        {
            return modifier
        }
        return NoModifier.default
    }
    
    /// `ImageProcessor` for processing when the downloading finishes.
    public var processor: ImageProcessor {
        if let item = lastMatchIgnoringAssociatedValue(.processor(DefaultImageProcessor.default)),
            case .processor(let processor) = item
        {
            return processor
        }
        return DefaultImageProcessor.default
    }

    /// `ImageModifier` for modifying right before the image is displayed.
    public var imageModifier: ImageModifier {
        if let item = lastMatchIgnoringAssociatedValue(.imageModifier(DefaultImageModifier.default)),
            case .imageModifier(let imageModifier) = item
        {
            return imageModifier
        }
        return DefaultImageModifier.default
    }
    
    /// `CacheSerializer` to convert image to data for storing in cache.
    public var cacheSerializer: CacheSerializer {
        if let item = lastMatchIgnoringAssociatedValue(.cacheSerializer(DefaultCacheSerializer.default)),
            case .cacheSerializer(let cacheSerializer) = item
        {
            return cacheSerializer
        }
        return DefaultCacheSerializer.default
    }
    
    /// Keep the existing image while setting another image to an image view. 
    /// Or the placeholder will be used while downloading.
    public var keepCurrentImageWhileLoading: Bool {
        return contains { $0 <== .keepCurrentImageWhileLoading }
    }
    
    public var onlyLoadFirstFrame: Bool {
        return contains { $0 <== .onlyLoadFirstFrame }
    }
    
    public var cacheOriginalImage: Bool {
        return contains { $0 <== .cacheOriginalImage }
    }
}
