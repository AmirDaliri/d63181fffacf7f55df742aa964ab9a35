
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

public protocol Placeholder {
    
    func add(to imageView: ImageView)
    
    func remove(from imageView: ImageView)
}

extension Placeholder where Self: Image {
    
    public func add(to imageView: ImageView) { imageView.image = self }
    
    public func remove(from imageView: ImageView) { imageView.image = nil }
}

extension Image: Placeholder {}

extension Placeholder where Self: View {
    
    public func add(to imageView: ImageView) {
        imageView.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0)
            ])
    }

    /// How the placeholder should be removed from a given image view.
    public func remove(from imageView: ImageView) {
        self.removeFromSuperview()
    }
}
