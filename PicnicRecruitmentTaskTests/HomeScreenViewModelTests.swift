//
//  HomeScreenViewModelTests.swift
//  PicnicRecruitmentTaskTests
//
//  Created by Jayesh Kawli on 7/11/22.
//

import XCTest
import Combine

@testable import PicnicRecruitmentTask

final class HomeScreenViewModelTests: XCTestCase {

    private var subscriptions: Set<AnyCancellable> = []
    
    func testThatViewModelCorrectlySetsTheStateWhenRandomGifIsSuccessfullyLoaded() {
        let networkService = MockNetworkService()
        let viewModel = HomeScreenViewModel(networkService: networkService)
        
        viewModel.loadRandomGif()
        
        XCTAssertEqual(viewModel.state, .loading)
        
        let expectation = XCTestExpectation(description: "View model correctly sets its state to randomGif enum value once the data is successfully loaded")
        
        viewModel.$state.sink { state in
            if case let .randomGif(gif) = state {
                XCTAssertEqual(gif.title, "school oops GIF by Cartoon Hangover" )
                XCTAssertEqual(gif.url.absoluteString, "https://media4.giphy.com/media/MX6fGl4ibWPGNotzzE/giphy.gif?cid=515786654afefe1b701ff1e722c33b7a035355a54c5b0d19&rid=giphy.gif&ct=g")
                XCTAssertEqual(gif.hash, "1660af7bf6773abaad7b0f0de2704b41")
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testThatViewModelCorrectlySetsTheStateWhenRandomGifFailsToLoad() {
        let networkService = MockNetworkService()
        networkService.toFail = true
        let viewModel = HomeScreenViewModel(networkService: networkService)

        viewModel.loadRandomGif()
        
        XCTAssertEqual(viewModel.state, .loading)
        
        XCTAssertFalse(viewModel.showAlert)
        
        let expectation = XCTestExpectation(description: "View model correctly sets its state to failed enum value if the request fails")
        
        viewModel.$state.sink { state in
            if case let .failed(errorViewModel) = state {
                XCTAssertTrue(viewModel.showAlert)
                XCTAssertEqual(errorViewModel.message, "Something went wrong while getting random GIF")
                
                if case .randomGif = errorViewModel.source {
                    // no-op
                    // If we reached here, that means we passed the test
                } else {
                    XCTFail("Failed to get expected source for the error view model. Expected randomGif")
                }
                
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testThatViewModelCorrectlySetsTheStateWhenGifSearchIsSuccessful() {
        let networkService = MockNetworkService()

        let viewModel = HomeScreenViewModel(networkService: networkService, isSearching: true)

        viewModel.searchText = "Testing"
        
        let expectation = XCTestExpectation(description: "View model correctly sets its state to searchedGifs enum value once the data is successfully loaded")
        
        viewModel.$state.sink { state in
            if case let .searchedGifs(gifs) = state {
                
                // First Gif
                XCTAssertEqual(gifs[0].title, "happy silent film GIF by Charlie Chaplin")
                XCTAssertEqual(gifs[0].url.absoluteString, "https://media3.giphy.com/media/55aWIFa04qi07FWNav/giphy.gif?cid=51578665k16k2p3bruihfh2452xpma9ub2b0f29m2j9r81kv&rid=giphy.gif&ct=g")
                XCTAssertEqual(gifs[0].hash, "0b237bb8e8597e834c3d40a87e90266e")
                
                // Second Gif
                XCTAssertEqual(gifs[1].title, "house GIF by Leesh")
                XCTAssertEqual(gifs[1].url.absoluteString, "https://media1.giphy.com/media/3o6Ztrs0GnTt4GkFO0/giphy.gif?cid=51578665k16k2p3bruihfh2452xpma9ub2b0f29m2j9r81kv&rid=giphy.gif&ct=g")
                XCTAssertEqual(gifs[1].hash, "b09ab34505064e68d372bd8ad3794642")
                
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
        
    }

    func testThatViewModelCorrectlySetsTheStateWhenGifSearchFails() {
        let networkService = MockNetworkService()
        networkService.toFail = true
        let viewModel = HomeScreenViewModel(networkService: networkService, isSearching: true)
        
        viewModel.searchText = "Test"
        
        let expectation = XCTestExpectation(description: "View model correctly sets its state to failed enum value if the request fails")
        
        viewModel.$state.sink { state in
            if case let .failed(errorViewModel) = state {
                XCTAssertTrue(viewModel.showAlert)
                XCTAssertEqual(errorViewModel.message, "Something went wrong while searching for GIF")
                
                if case let .searchGif(searchText) = errorViewModel.source {
                    XCTAssertEqual(searchText, "Test")
                } else {
                    XCTFail("Failed to get expected source for the error view model. Expected searchGif")
                }
                expectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testThatTimerPublisherIsNilWhenUserIsActivelySearching() {
        let networkService = MockNetworkService()
        let viewModel = HomeScreenViewModel(networkService: networkService, isSearching: true)
        
        XCTAssertNil(viewModel.timerPublisher)
    }
    
    func testThatTimerPublisherIsNotNilWhenUserIsNotActivelySearching() {
        let networkService = MockNetworkService()
        let viewModel = HomeScreenViewModel(networkService: networkService)
        
        XCTAssertNotNil(viewModel.timerPublisher)
    }
}
