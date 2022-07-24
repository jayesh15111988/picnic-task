//
//  GifAnimatedImage.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/24/22.
//

import SwiftUI
import FLAnimatedImage

struct GifAnimatedImage: UIViewRepresentable {

    let data: Data?
    let placeholderImageName: String

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

        if let data = data {
            imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
        } else {
            imageView.image = UIImage(named: "")
        }

        return view
    }

  func updateUIView(_ uiView: UIView, context: Context) {
      // no-op
  }
}

