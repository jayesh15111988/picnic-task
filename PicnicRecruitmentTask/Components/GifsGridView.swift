//
//  GifsGridView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/22/22.
//

import SwiftUI

struct GifsGridView: View {

    let gifImages: [GifImageViewModel]

    private let gridItemLayout = (0...2).map { _ in
        GridItem(.flexible())
    }

    let serialQueue = DispatchQueue(label: "GIF Loading Queue")

    @State private var isAnimatingGifImage = false

    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: Spacing.small) {
            ForEach(gifImages.indices, id: \.self) { index in

                let gifImage = gifImages[index]

                NavigationLink(destination: gifDetailsView(from: gifImage)) {
                    VStack(spacing: 0) {
                        GifAnimatedImage(url: gifImage.url, placeholderImageName: "search", sequence: index, serialQueue: serialQueue)
                            .frame(minWidth: 100, minHeight: 100)
                            .scaledToFit()
                    }
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
