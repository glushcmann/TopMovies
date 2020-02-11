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
    let formatter = DateFormatter()
    @State private var show_modal: Bool = false

        
    var body: some View {
        List {
            ForEach(movies) { movie in
                HStack {
                    MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.posterPath, size: .medium),posterSize: .medium)
                    VStack {
                        HStack {
                            PopularityBadge(score: Int(movie.voteAverage), isDisplayed: true)
                            VStack(alignment: .leading) {
                                Text("\(movie.title)").font(.title)
                                Text("\(movie.releaseDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .padding(.bottom)
                            }
                        }
                        HStack {
//                            Text(DateFormatter.string(movie.releaseDate))
//                            Text(formatter.string(from: movie.releaseDate))
//                              .font(.subheadline)
//                              .foregroundColor(.primary)
                            Text("\(movie.overview)")
                                .lineLimit(3)
                        }
                        Button(action: {
                            print("Button Pushed")
                            self.show_modal = true
                        }) {
                            Text("Schedule viewing")
                        }.padding(.top).sheet(isPresented: self.$show_modal) {
                             TestView()
                            }
                    }
                }
            }
        }
    }
}

struct TestView: View {
    var body: some View {
        EKEventWrapper(isShowing: .constant(false))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(MoviesViewModel())
    }
}
