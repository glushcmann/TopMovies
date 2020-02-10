//
//  ContentView.swift
//  TopMovies
//
//  Created by Никита on 06.02.2020.
//  Copyright © 2020 Nikita Glushchenko. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var moviesViewModel: MoviesViewModel
    
    var body: some View {
        VStack {
            Text("\(moviesViewModel.indexEndpoint)")
            Stepper("Enter your index" , value:
                $moviesViewModel.indexEndpoint, in: 0...3)
                .padding()
            Picker("", selection: $moviesViewModel.indexEndpoint) {
                Text("\(Endpoint(index: 0)!.description)").tag(0)
                Text("\(Endpoint(index: 1)!.description)").tag(1)
                Text("\(Endpoint(index: 2)!.description)").tag(2)
                Text("\(Endpoint(index: 3)!.description)").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            MoviesList(movies: moviesViewModel.movies)
        }
    }
}

struct MoviesList: View {
    var movies: [Movie]
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                HStack {
                    MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.posterPath, size: .medium),posterSize: .medium)
                    VStack(alignment: .leading) {
                        Text("\(movie.title)").font(.title)
                        HStack {
//                          Text(Formatter.string(from: movie.releaseDate))
//                              .font(.subheadline)
//                              .foregroundColor(.primary)
                            Text("\(movie.overview)")
                                .lineLimit(3)
                        }
                    }
                }
            }
        }
    }
}

//struct MoviePosterImage: View {
//    @ObservedObject var imageLoader: ImageLoader
//    @State var isImageLoaded: Bool = false
//    //let posterSize: PosterStyle.size
//    
//    var body: some View {
//        ZStack {
//            if self.imageLoader.image != nil {
//                Image(uiImage: self.imageLoader.image!)
//                    .resizable()
//                    .renderingMode(.original)
//                    //.PosterStyle(loaded: true, size: posterSize)
//                    .animation(.easeInOut)
//                    .onAppear {
//                        self.isImageLoaded = true
//                }
//            } else {
//                Rectangle()
//                    .foregroundColor(.gray)
//                    //.PosterStyle(loaded: true, size: posterSize)
//            }
//            }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(MoviesViewModel())
    }
}
