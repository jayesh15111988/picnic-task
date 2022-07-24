//
//  GifImage.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import Foundation

// An enum to store ratings associated with each Gif
enum ImageRating: String, Decodable {
    case g
    case pg
    case pg13 = "pg-13"
    case r
}

// A Codable structure to decode incoming Gif JSON data
struct GifImage: Equatable, Decodable, Identifiable {
    
    let id: String
    let title: String
    let rating: ImageRating
    let hash: String
    let url: URL
    let data: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case rating
        case images
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decode(ImageRating.self, forKey: .rating)
        
        let originalImage = try container.decode(OriginalImage.self, forKey: .images)
        let image = originalImage.original
        self.hash = image.hash
        self.url = image.url
        self.data = try? Data(contentsOf: image.url)
    }
    
    static func ==(lhs: GifImage, rhs: GifImage) -> Bool {
        return lhs.id == rhs.id && lhs.hash == rhs.hash
    }
}

struct OriginalImage: Decodable {
    let original: GifImageData
}

struct GifImageData: Decodable {
    let hash: String
    let url: URL
}
