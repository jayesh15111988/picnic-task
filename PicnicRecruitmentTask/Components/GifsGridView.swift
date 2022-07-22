//
//  GifsGridView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/22/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifsGridView: View {

    let gifImages: [GifImageViewModel]

    private let gridItemLayout = (0...2).map { _ in
        GridItem(.flexible())
    }

    @State private var isAnimatingGifImage = false

    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: Spacing.small) {
            ForEach(gifImages) { gifImage in
                NavigationLink(destination: gifDetailsView(from: gifImage)) {
                    AnimatedImage(url: gifImage.url, isAnimating: $isAnimatingGifImage).placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                }
            }
        }
    }

    @ViewBuilder func gifDetailsView(from gifImageViewModel: GifImageViewModel) -> some View {
        GifDetailsView(gifImageViewModel: gifImageViewModel)
            .navigationTitle(gifImageViewModel.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct GifsGridView_Previews: PreviewProvider {
    static var previews: some View {
        GifsGridView(gifImages: [])
    }
}
