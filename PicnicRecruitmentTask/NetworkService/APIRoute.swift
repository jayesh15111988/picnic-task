//
//  APIRoute.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/23/22.
//

import Foundation

// A breadcrumb representing tail ends of URLs
// More breadcrumbs can be added as necessary in the future
enum EndpointBreadcrumbs: String {
    case random
    case search
}

enum APIRoute {
    case getRandomGif
    case searchGifs(String)

    private struct URLParameters {
        static let apiKey = "T2nHDbDDMZcxBZNc0q101MlmFYbybg1Y"
        static let maxGifsCountPerSearchRequest = 20
    }

    private var baseURLString: String {
        "https://api.giphy.com/v1/gifs/"
    }

    private var url: URL? {
        switch self {
        case .getRandomGif:
            return URL(string: baseURLString + EndpointBreadcrumbs.random.rawValue)
        case .searchGifs:
            return URL(string: baseURLString + EndpointBreadcrumbs.search.rawValue)
        }
    }

    private var parameters: [URLQueryItem] {

        var queryParameters = [URLQueryItem(name: "api_key", value: URLParameters.apiKey)]

        switch self {
        case .getRandomGif:
            break
        case .searchGifs(let searchText):
            queryParameters.append(URLQueryItem(name: "limit", value: String(URLParameters.maxGifsCountPerSearchRequest)))
            queryParameters.append(URLQueryItem(name: "q", value: searchText))
        }
        return queryParameters
    }

    func asRequest() -> URLRequest {
        guard let url = url else {
            preconditionFailure("Missing URL for route: \(self)")
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters

        guard let parametrizedURL = components?.url else {
            preconditionFailure("Missing URL with parameters for url: \(url)")
        }

        return URLRequest(url: parametrizedURL)
    }
}
