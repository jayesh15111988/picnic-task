//
//  HomeScreenViewModel.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import Foundation
import SwiftUI
import Combine
import FLAnimatedImage

// An enum representing the source of error
// For example, error could originate while getting a random Gif
// Or while searching for Gifs with the given keyword
enum ErrorSource: Equatable {
    case randomGif
    case searchGif(String)
}

struct ErrorViewModel: Equatable {
    let title: String
    let message: String
    let source: ErrorSource
}

struct GifImageViewModel: Equatable, Identifiable {
    var id: String {
        return url.absoluteString
    }
    let title: String
    let url: URL
    let pgRatingImage: Image
    let hash: String

    var urlString: String {
        url.absoluteString
    }
}

enum LoadingState: Equatable {
    case idle
    case loading
    case failed(ErrorViewModel)
    case searchedGifs([GifImageViewModel])
    case randomGif(GifImageViewModel)
}

final class HomeScreenViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var showAlert = false
    @Published var headerTitle = ""
    
    @Published private(set) var state: LoadingState = .idle
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private struct Constants {
        static let timerInterval = 10.0 // Timer interval in seconds
        static let minimumNumberOfCharacters = 3 // Minimum number of characters to type before search is triggered
    }
    
    var timerPublisher: AnyCancellable?
    private var searchGifsPublisher: AnyCancellable?
    private var getRandomGifPublisher: AnyCancellable?
    
    private let networkService: NetworkService
    private let cache: Cacheable
    
    init(networkService: NetworkService, isSearching: Bool = false, cache: Cacheable = Cache.shared) {
        self.networkService = networkService
        self.isSearching = isSearching
        self.cache = cache
        
        searchGifsPublisher = $searchText
            .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= Constants.minimumNumberOfCharacters }
            .sink { [weak self] in
                
                guard let self = self else { return }
                
                self.headerTitle = "Search Results:"
                
                self.searchGifs(with: $0)
            }

        self.$isSearching.sink { [weak self] isSearching in
            
            guard let self = self else { return }
            
            if isSearching {
                guard self.timerPublisher != nil else { return }
                self.timerPublisher?.cancel()
                self.timerPublisher = nil
            } else {
                self.headerTitle = "Random Selected GIF:"
                self.timerPublisher = Timer.publish(every: Constants.timerInterval, on: .main, in: .common)
                    .autoconnect()
                    .merge(with: Just(Date())).sink { [weak self] _ in
                    self?.loadRandomGif()
                }
            }
        }.store(in: &subscriptions)
    }
    
    private func searchGifs(with searchText: String) {
        self.state = .loading
        
        networkService
            .requestForObject(apiRoute: .searchGifs(searchText))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.showAlert = true

                    // TODO in future: In case of failure, log the error message locally
                    // For later debugging and also log them on appropriate
                    // Servers for later monitoring

                    self.setFinalState(with: .failed(ErrorViewModel(title: "Error", message: error.errorMessageString(), source: .searchGif(searchText))))
                default:
                    break
                }
            } receiveValue: { [weak self] (gifSearchImagesContainer: GifSearchImagesContainer) in
                
                guard let self = self else { return }

                let gifs = gifSearchImagesContainer.data
                
                guard !gifs.isEmpty else {
                    self.showAlert = true
                    self.setFinalState(with: .failed(ErrorViewModel(title: "No Gifs Found", message: "Could not find any search results for search text '\(searchText)'", source: .searchGif(self.searchText))))
                    return
                }
                self.setFinalState(with: .searchedGifs(gifs.map { GifImageViewModel(title: $0.title, url: $0.url, pgRatingImage: Image($0.rating.rawValue), hash: $0.hash) }))
            }.store(in: &self.subscriptions)
    }
    
    func loadRandomGif() {
        // Cancel the previous request if it's still in flight
        getRandomGifPublisher?.cancel()
        
        self.state = .loading

        getRandomGifPublisher = networkService
            .requestForObject(apiRoute: .getRandomGif)
            .receive(on: DispatchQueue.main).sink { [weak self] completion in
                
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.showAlert = true
                    
                    // TODO in future: In case of failure, log the error message locally
                    // For later debugging and also log them on appropriate
                    // Servers for later monitoring

                    self.setFinalState(with: .failed(ErrorViewModel(title: "Error", message: error.errorMessageString(), source: .randomGif)))
                default:
                    break
                }
            } receiveValue: { [weak self] (randomGifContainer: GifImageContainer) in

                guard let self = self else { return }

                let randomGif = randomGifContainer.data
                self.setFinalState(with: .randomGif(GifImageViewModel(title: randomGif.title, url: randomGif.url, pgRatingImage: Image(randomGif.rating.rawValue), hash: randomGif.hash)))
            }
    }

    private func setFinalState(with state: LoadingState) {
        DispatchQueue.global(qos: .background).async {
            self.cache.clearCache()
            DispatchQueue.main.async {
                self.state = state
            }
        }
    }

    func retryLastRequest(from source: ErrorSource) {
        switch source {
        case .randomGif:
            self.loadRandomGif()
        case .searchGif(let searchKeyword):
            self.searchGifs(with: searchKeyword)
        }
    }
}
