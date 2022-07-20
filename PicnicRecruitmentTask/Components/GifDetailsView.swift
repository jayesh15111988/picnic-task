//
//  GifDetailsView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifDetailsView: View {
    
    let gifImageViewModel: GifImageViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                AnimatedImage(url: gifImageViewModel.url).placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFit()

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

struct GifDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GifDetailsView(gifImageViewModel: GifImageViewModel(title: "Test GIF", url: URL(string: "https://media1.giphy.com/media/N5lbhqFmbJfG6YfNIa/giphy.gif?cid=51578665bcd9283e3f7e8c70372adbe5681d5589f75a6be9&rid=giphy.gif&ct=g")!, pgRatingImage: Image(ImageRating.pg13.rawValue), hash: "abc123"))
    }
}

