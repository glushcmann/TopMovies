//
//  ImageLoader.swift
//  TopMovies
//
//  Created by Никита on 07.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import UIKit
import Combine

class ImageLoaderCache {
    static let shared = ImageLoaderCache()
    var loaders: NSCache<NSString, ImageLoader> = NSCache()
            
    func loaderFor(path: String?, size: ImageService.Size) -> ImageLoader {
        let key = NSString(string: "\(path ?? "missing")#\(size.rawValue)")
        if let loader = loaders.object(forKey: key) {
            return loader
        } else {
            let loader = ImageLoader(path: path, size: size)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}

final class ImageLoader: ObservableObject {
    let path: String?
    let size: ImageService.Size
    
   var objectWillChange: AnyPublisher<UIImage?, Never> =
    Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    
    @Published var image: UIImage? = nil
    
    var cancellable: AnyCancellable?
        
    init(path: String?, size: ImageService.Size) {
        self.size = size
        self.path = path
        
       self.objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] sub in
            self?.loadImage()
        }, receiveCancel: { [weak self] in
            self?.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }
    
    private func loadImage() {
        guard let poster = path, image == nil else {
            return
        }
        cancellable = ImageService.shared.fetchImage(poster: poster, size: size)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
 
    deinit {
        cancellable?.cancel()
    }
}
