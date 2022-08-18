//
//  GifAnimatedImage.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/24/22.
//

import SwiftUI
import FLAnimatedImage

struct GifAnimatedImage: UIViewRepresentable {

    let url: URL?
    let placeholderImageName: String
    let sequence: Int
    let cache: Cacheable

    init(url: URL?, placeholderImageName: String, sequence: Int, cache: Cacheable = Cache.shared) {
        self.url = url
        self.placeholderImageName = placeholderImageName
        self.sequence = sequence
        self.cache = cache
    }

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

extension GifAnimatedImage {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        imageView.image = UIImage(named: placeholderImageName)

        return view
    }

  func updateUIView(_ uiView: UIView, context: Context) {

      guard let url = url else {
          print("Failed")
          return
      }

      if let image = cache.getImage(for: url) {
          imageView.animatedImage = image
          print("Used Cached value")
          return
      }

      print("Getting data now")
      DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url) {
              let image = FLAnimatedImage(animatedGIFData: data)
              cache.store(image: image, for: url)
              print("Stored in cache")
              DispatchQueue.main.async {
                  imageView.animatedImage = image
                  print("Applied to image")
              }
          } else {
              print("Failed")
          }
      }
  }
}

