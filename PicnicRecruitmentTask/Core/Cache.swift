//
//  Cache.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/25/22.
//

import Foundation
import FLAnimatedImage

protocol Cacheable {
    func store(image: FLAnimatedImage?, for url: URL)
    func getImage(for url: URL) -> FLAnimatedImage?
    func clearCache()
    func size() -> Int
}

final class Cache: Cacheable {

    static let shared = Cache()

    let concurrentQueue = DispatchQueue(label: "com.picnic.gif.cache-queue", attributes: .concurrent)

    var store: [URL: FLAnimatedImage] = [:]

    private init() {

    }

    func store(image: FLAnimatedImage?, for url: URL) {
        concurrentQueue.sync(flags: .barrier) {
            if let image = image {
                store[url] = image
            }
        }
    }

    func getImage(for url: URL) -> FLAnimatedImage? {
        return concurrentQueue.sync {
            store[url]
        }
    }

    func clearCache() {
        concurrentQueue.sync(flags: .barrier) {
            store.removeAll()
        }
    }

    func size() -> Int {
        return store.count
    }
}
