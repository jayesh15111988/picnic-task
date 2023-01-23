//
//  GifDetailsView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI

struct GifDetailsView: View {
    
    let gifImageViewModel: GifImageViewModel
    let serialQueue = DispatchQueue(label: "git details view serial queue")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                GifAnimatedImage(url: gifImageViewModel.url, placeholderImageName: "search", sequence: 0, serialQueue: serialQueue)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .padding()

                Divider()
                
                Text(gifImageViewModel.title)
                
                Divider()
                
                Text(gifImageViewModel.urlString)
                
                Divider()
                
                gifImageViewModel.pgRatingImage
                    .resizable()
                    .scaledToFit()
                
                Divider()
            }.padding()
        }
    }
}
