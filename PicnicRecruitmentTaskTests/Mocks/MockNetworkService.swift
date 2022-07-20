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
    
    func getRandomGif() -> AnyPublisher<GifImage, DataLoadError> {
        if toFail {
            return Fail(error: DataLoadError.genericError("Something went wrong while getting random GIF")).eraseToAnyPublisher()
        }
        
        if let randomGifData = JSONDataReader.getDataFromJSONFile(with: "random_gif") {
            if let decodedGifData = try? JSONDecoder().decode(GifImageContainer.self, from: randomGifData) {
                return Just<GifImage>(decodedGifData.data).setFailureType(to: DataLoadError.self).eraseToAnyPublisher()
            } else {
                XCTFail("Failed to convert data into valid GifImage object")
            }
        } else {
            XCTFail("Failed to get valid random Gif data from local JSON file")
        }
        fatalError("Cannot continue with test. Failed to get valid object from local JSON file")
    }
    
    func searchGifs(searchText: String) -> AnyPublisher<[GifImage], DataLoadError> {
        if toFail {
            return Fail(error: DataLoadError.genericError("Something went wrong while searching for GIF")).eraseToAnyPublisher()
        }
        
        if let randomGifData = JSONDataReader.getDataFromJSONFile(with: "search_gifs") {
            if let decodedGifsData = try? JSONDecoder().decode(GifSearchImagesContainer.self, from: randomGifData) {
                return Just<[GifImage]>(decodedGifsData.data).setFailureType(to: DataLoadError.self).eraseToAnyPublisher()
            } else {
                XCTFail("Failed to convert data into valid array of GifImage objects")
            }
        } else {
            XCTFail("Failed to get valid searched Gifs data from local JSON file")
        }
        fatalError("Cannot continue with test. Failed to get valid object from local JSON file")
    }
}
