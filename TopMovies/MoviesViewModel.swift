//
//  MoviesViewModel.swift
//  TopMovies
//
//  Created by Никита on 06.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Combine

final class MoviesViewModel: ObservableObject {
    var movieAPI = MovieStore.shared
    
    // input
    @Published var indexEndpoint: Int = 1
    // output
    @Published var movies = [Movie]()
    
    @Published var moviesError: MovieStoreAPIError?
    
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        $indexEndpoint
            .setFailureType(to: MovieStoreAPIError.self)
            .flatMap { (indexEndpoint) -> AnyPublisher<[Movie], MovieStoreAPIError> in
                self.movieAPI.fetchMovies(from:  Endpoint( index: indexEndpoint)!)
                    .eraseToAnyPublisher()
        }
        .sink(receiveCompletion:  {[unowned self] (completion) in
            if case let .failure(error) = completion {
                self.moviesError = error
            }},
              receiveValue: { [unowned self] in self.movies = $0
        })
            .store(in: &self.cancellableSet)
    }
 
    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
}
