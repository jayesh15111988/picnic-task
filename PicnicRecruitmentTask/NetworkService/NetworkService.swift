//
//  NetworkService.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import Foundation
import Combine

// A protocol for network service.
// More protocol methods can be added to extend the existing functionality
protocol NetworkService {
    func getRandomGif() -> AnyPublisher<GifImage, DataLoadError>
    func searchGifs(searchText: String) -> AnyPublisher<[GifImage], DataLoadError>
}

// A breadcrumb representing tail ends of URLs
// More breadcrumbs can be added as necessary in the future
enum EndpointBreadcrumbs: String {
    case random
    case search
}

struct NetworkServiceImpl: NetworkService {
    
    private struct URLParameters {
        static let baseURL = "https://api.giphy.com/v1/gifs/"
        static let apiKey = "T2nHDbDDMZcxBZNc0q101MlmFYbybg1Y"
        static let maxGifsCountPerSearchRequest = 25
    }
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// A method to get random Gif from the server
    /// - Returns: A Publisher with output of type GifImage and error of type DataLoadError
    func getRandomGif() -> AnyPublisher<GifImage, DataLoadError> {

        let queryItems = [URLQueryItem(name: "api_key", value: URLParameters.apiKey)]
            
        let urlComponents = NSURLComponents(string: URLParameters.baseURL + EndpointBreadcrumbs.random.rawValue)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: DataLoadError.badURL).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200..<300) ~= httpResponse.statusCode else {
                        throw DataLoadError.invalidResponseCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .decode(type: GifImageContainer.self, decoder: JSONDecoder())
            .mapError { error -> DataLoadError in
                if let decodingError = error as? DecodingError {
                    return DataLoadError.decodingError((decodingError as NSError).debugDescription)
                }
                return DataLoadError.genericError(error.localizedDescription)
            }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    
    /// A method to search Gifs on the server
    /// - Parameter searchText: A text on which to search Gifs on the remote server
    /// - Returns: A Publisher with output of array of type GifImage and error of type DataLoadError
    func searchGifs(searchText: String) -> AnyPublisher<[GifImage], DataLoadError> {
        
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "api_key", value: URLParameters.apiKey))

        queryItems.append(URLQueryItem(name: "limit", value: String(URLParameters.maxGifsCountPerSearchRequest)))

        queryItems.append(URLQueryItem(name: "q", value: searchText))
            
        let urlComponents = NSURLComponents(string: URLParameters.baseURL + EndpointBreadcrumbs.search.rawValue)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: DataLoadError.badURL).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200..<300) ~= httpResponse.statusCode else {
                        throw DataLoadError.invalidResponseCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .decode(type: GifSearchImagesContainer.self, decoder: JSONDecoder())
            .mapError { error -> DataLoadError in
                if let decodingError = error as? DecodingError {
                    return DataLoadError.decodingError((decodingError as NSError).debugDescription)
                }
                return DataLoadError.genericError(error.localizedDescription)
            }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
