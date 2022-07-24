//
//  GifDetailsView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI

struct GifDetailsView: View {
    
    let gifImageViewModel: GifImageViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                GifAnimatedImage(url: gifImageViewModel.url, placeholderImageName: "search").frame(maxWidth: .infinity, minHeight: 200).padding()
//                AnimatedImage(url: gifImageViewModel.url).placeholder {
//                    ProgressView()
//                }
//                .resizable()
//                .scaledToFit()

                Divider()
                
                Text(gifImageViewModel.title)
                
                Divider()
                
                Text(gifImageViewModel.url.absoluteString)
                
                Divider()
                
                gifImageViewModel.pgRatingImage
                    .resizable()
                    .scaledToFit()
                
                Divider()
            }.padding()
        }
    }
}
