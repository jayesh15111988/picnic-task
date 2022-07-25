//
//  MockNetworkService.swift
//  PicnicRecruitmentTaskTests
//
//  Created by Jayesh Kawli on 7/11/22.
//

import Foundation
import Combine

@testable import PicnicRecruitmentTask
import XCTest

final class MockNetworkService: NetworkService {
    
    var toFail = false
    
    func requestForObject<T: Decodable>(apiRoute: APIRoute) -> AnyPublisher<T, DataLoadError> {

        switch apiRoute {
        case .getRandomGif:

            if toFail {
                return Fail(error: DataLoadError.genericError("Something went wrong while getting random GIF")).eraseToAnyPublisher()
            }

            if let randomGifData = JSONDataReader.getDataFromJSONFile(with: "random_gif") {
                if let decodedGifData = try? JSONDecoder().decode(T.self, from: randomGifData) {
                    return Just<T>(decodedGifData).setFailureType(to: DataLoadError.self).eraseToAnyPublisher()
                } else {
                    XCTFail("Failed to convert data into valid GifImage object")
                }
            } else {
                XCTFail("Failed to get valid random Gif data from local JSON file")
            }
        case .searchGifs:
            if toFail {
                return Fail(error: DataLoadError.genericError("Something went wrong while searching for GIF")).eraseToAnyPublisher()
            }

            if let searchGifData = JSONDataReader.getDataFromJSONFile(with: "search_gifs") {
                if let decodedGifsData = try? JSONDecoder().decode(T.self, from: searchGifData) {
                    return Just<T>(decodedGifsData).setFailureType(to: DataLoadError.self).eraseToAnyPublisher()
                } else {
                    XCTFail("Failed to convert data into valid array of GifImage objects")
                }
            } else {
                XCTFail("Failed to get valid searched Gifs data from local JSON file")
            }
        }
        fatalError("Unexpected state. Control should not reach this line. Expected known cases. Received new case \(apiRoute)")
    }
}
