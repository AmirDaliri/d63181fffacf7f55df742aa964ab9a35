

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif



public typealias PrefetcherProgressBlock = ((_ skippedResources: [Resource], _ failedResources: [Resource], _ completedResources: [Resource]) -> Void)


public typealias PrefetcherCompletionHandler = ((_ skippedResources: [Resource], _ failedResources: [Resource], _ completedResources: [Resource]) -> Void)


public class ImagePrefetcher {
    
    /// The maximum concurrent downloads to use when prefetching images. Default is 5.
    public var maxConcurrentDownloads = 5
    
    /// The dispatch queue to use for handling resource process so downloading does not occur on the main thread
    /// This prevents stuttering when preloading images in a collection view or table view
    private var prefetchQueue: DispatchQueue
    
    private let prefetchResources: [Resource]
    private let optionsInfo: KingfisherOptionsInfo
    private var progressBlock: PrefetcherProgressBlock?
    private var completionHandler: PrefetcherCompletionHandler?
    
    private var tasks = [URL: RetrieveImageDownloadTask]()
    
    private var pendingResources: ArraySlice<Resource>
    private var skippedResources = [Resource]()
    private var completedResources = [Resource]()
    private var failedResources = [Resource]()
    
    private var stopped = false
    
    // The created manager used for prefetch. We will use the helper method in manager.
    private let manager: KingfisherManager
    
    private var finished: Bool {
        return failedResources.count + skippedResources.count + completedResources.count == prefetchResources.count && self.tasks.isEmpty
    }
    

    public convenience init(urls: [URL],
                         options: KingfisherOptionsInfo? = nil,
                   progressBlock: PrefetcherProgressBlock? = nil,
               completionHandler: PrefetcherCompletionHandler? = nil)
    {
        let resources: [Resource] = urls.map { $0 }
        self.init(resources: resources, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    

    public init(resources: [Resource],
                  options: KingfisherOptionsInfo? = nil,
            progressBlock: PrefetcherProgressBlock? = nil,
        completionHandler: PrefetcherCompletionHandler? = nil)
    {
        prefetchResources = resources
        pendingResources = ArraySlice(resources)
        
        // Set up the dispatch queue that all our work should occur on.
        let prefetchQueueName = "com.onevcat.Kingfisher.PrefetchQueue"
        prefetchQueue = DispatchQueue(label: prefetchQueueName)
        
        // We want all callbacks from our prefetch queue, so we should ignore the call back queue in options
        var optionsInfoWithoutQueue = options?.removeAllMatchesIgnoringAssociatedValue(.callbackDispatchQueue(nil)) ?? KingfisherEmptyOptionsInfo
        
        // Add our own callback dispatch queue to make sure all callbacks are coming back in our expected queue
        optionsInfoWithoutQueue.append(.callbackDispatchQueue(prefetchQueue))
        
        self.optionsInfo = optionsInfoWithoutQueue
        
        let cache = self.optionsInfo.targetCache ?? .default
        let downloader = self.optionsInfo.downloader ?? .default
        manager = KingfisherManager(downloader: downloader, cache: cache)
        
        self.progressBlock = progressBlock
        self.completionHandler = completionHandler
    }
    

    public func start()
    {
        // Since we want to handle the resources cancellation in the prefetch queue only.
        prefetchQueue.async {
            
            guard !self.stopped else {
                assertionFailure("You can not restart the same prefetcher. Try to create a new prefetcher.")
                self.handleComplete()
                return
            }
            
            guard self.maxConcurrentDownloads > 0 else {
                assertionFailure("There should be concurrent downloads value should be at least 1.")
                self.handleComplete()
                return
            }
            
            guard self.prefetchResources.count > 0 else {
                self.handleComplete()
                return
            }
            
            let initialConcurentDownloads = min(self.prefetchResources.count, self.maxConcurrentDownloads)
            for _ in 0 ..< initialConcurentDownloads {
                if let resource = self.pendingResources.popFirst() {
                    self.startPrefetching(resource)
                }
            }
        }
    }

   
    /**
     Stop current downloading progress, and cancel any future prefetching activity that might be occuring.
     */
    public func stop() {
        prefetchQueue.async {
            if self.finished { return }
            self.stopped = true
            self.tasks.values.forEach { $0.cancel() }
        }
    }
    
    func downloadAndCache(_ resource: Resource) {

        let downloadTaskCompletionHandler: CompletionHandler = { (image, error, _, _) -> Void in
            self.tasks.removeValue(forKey: resource.downloadURL)
            if let _ = error {
                self.failedResources.append(resource)
            } else {
                self.completedResources.append(resource)
            }
            
            self.reportProgress()
            if self.stopped {
                if self.tasks.isEmpty {
                    self.failedResources.append(contentsOf: self.pendingResources)
                    self.handleComplete()
                }
            } else {
                self.reportCompletionOrStartNext()
            }
        }
        
        let downloadTask = manager.downloadAndCacheImage(
            with: resource.downloadURL,
            forKey: resource.cacheKey,
            retrieveImageTask: RetrieveImageTask(),
            progressBlock: nil,
            completionHandler: downloadTaskCompletionHandler,
            options: optionsInfo)
        
        if let downloadTask = downloadTask {
            tasks[resource.downloadURL] = downloadTask
        }
    }
    
    func append(cached resource: Resource) {
        skippedResources.append(resource)
 
        reportProgress()
        reportCompletionOrStartNext()
    }
    
    func startPrefetching(_ resource: Resource)
    {
        if optionsInfo.forceRefresh {
            downloadAndCache(resource)
        } else {
            let alreadyInCache = manager.cache.imageCachedType(forKey: resource.cacheKey,
                                                             processorIdentifier: optionsInfo.processor.identifier).cached
            if alreadyInCache {
                append(cached: resource)
            } else {
                downloadAndCache(resource)
            }
        }
    }
    
    func reportProgress() {
        progressBlock?(skippedResources, failedResources, completedResources)
    }
    
    func reportCompletionOrStartNext() {
        prefetchQueue.async {
            if let resource = self.pendingResources.popFirst() {
                self.startPrefetching(resource)
            } else {
                guard self.tasks.isEmpty else { return }
                self.handleComplete()
            }
        }
    }
    
    func handleComplete() {
        // The completion handler should be called on the main thread
        DispatchQueue.main.safeAsync {
            self.completionHandler?(self.skippedResources, self.failedResources, self.completedResources)
            self.completionHandler = nil
            self.progressBlock = nil
        }
    }
}
