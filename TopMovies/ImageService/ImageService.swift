//
//  ImageService.swift
//  TopMovies
//
//  Created by Никита on 07.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Combine
import UIKit
import SwiftUI

//class ImageLoaderCache {
//    static let shared = ImageLoaderCache()
//    
//    var loaders: NSCache<NSString, ImageLoader> = NSCache()
//            
//    func loaderFor(path: String?, size: ImageService.Size) -> ImageLoader {
//        let key = NSString(string: "\(path ?? "missing")#\(size.rawValue)")
//        if let loader = loaders.object(forKey: key) {
//            return loader
//        } else {
//            let loader = ImageLoader(path: path, size: size)
//            loaders.setObject(loader, forKey: key)
//            return loader
//        }
//    }
//}

class ImageService {
    static let shared = ImageService()
    
    enum Size: String {
        case small = "http://image.tmdb.org/t/p/w154/"
        case medium = "http://image.tmdb.org/t/p/w500/"
        case cast = "http://image.tmdb.org/t/p/w185/"
        case original = "http://image.tmdb.org/t/p/original/"
        
        func path(poster: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(poster)
        }
    }
    
    func fetchImage(poster: String, size: Size) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: size.path(poster: poster))
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)
        }.catch { error in
            return Just(nil)
        }
    .eraseToAnyPublisher()
    }
}

//final class ImageLoader: ObservableObject {
//    let path: String?
//    let size: ImageService.Size
//    
//    var objectWillChange: AnyPublisher<UIImage?, Never> =
//        Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
//    
//    @Published var image: UIImage? = nil
//    
//    var cancellable: AnyCancellable?
//    
//    init(path: String?, size: ImageService.Size) {
//        self.size = size
//        self.path = path
//        
//        self.objectWillChange = $image.handleEvents(
//            receiveSubscription: { [weak self] sub in self?.loadImage()},
//            receiveCancel: { [weak self] in self?.cancellable?.cancel()
//            }).eraseToAnyPublisher()
//    }
//    
//    private func loadImage() {
//        guard let poster = path, image == nil else {
//            return
//        }
//        cancellable = ImageService.shared.fetchImage(poster: poster, size: size)
//            .receive(on: DispatchQueue.main)
//            .assign(to: \ImageLoader.image, on: self)
//    }
//
//    deinit {
//        cancellable?.cancel()
//    }
//}
