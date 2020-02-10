//
//  MovieStoreAPIError.swift
//  TopMovies
//
//  Created by Никита on 06.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import Foundation

enum MovieStoreAPIError: Error, LocalizedError {
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case genericError
    
    var localizedDescription: String {
        switch self {
        case .urlError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .responseError(let status):
            return "Bad response code: \(status)"
        case .genericError:
            return "An unknown error has been occured"
        }
    }
}


