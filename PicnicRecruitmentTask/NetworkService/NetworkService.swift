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
    func requestForObject<T: Decodable>(apiRoute: APIRoute) -> AnyPublisher<T, DataLoadError>
}

struct NetworkServiceImpl: NetworkService {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// A method to get a single object from server
    /// - Returns: A Publisher with output of type GifImage and error of type DataLoadError
    func requestForObject<T: Decodable>(apiRoute: APIRoute) -> AnyPublisher<T, DataLoadError> {

        return urlSession.dataTaskPublisher(for: apiRoute.asRequest())
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode == 200 else {
                        throw DataLoadError.invalidResponseCode(httpResponse.statusCode)
                    }
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> DataLoadError in
                if let decodingError = error as? DecodingError {
                    return DataLoadError.decodingError((decodingError as NSError).debugDescription)
                }
                return DataLoadError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
