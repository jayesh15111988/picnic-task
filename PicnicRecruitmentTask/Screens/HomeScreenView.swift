//
//  HomeScreenView.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeScreenView: View {
    
    @ObservedObject var viewModel: HomeScreenViewModel
    
    @State private var isAnimatingGifImage = false
    
    private let gridItemLayout = (0...2).map { _ in
        GridItem(.flexible())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(searchText: $viewModel.searchText, isSearching: $viewModel.isSearching)
                Text(viewModel.headerTitle)
                    .padding(.vertical, Spacing.medium)
                ScrollView {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                    case .randomGif(let gifImage):
                        GifDetailsView(gifImageViewModel: gifImage)
                    case .searchedGifs(let gifImages):
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
                    case .failed(let errorViewModel):
                        showAlert(with: errorViewModel)
                    case .idle:
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
            .frame(alignment: .leading)
        }
    }
    
    @ViewBuilder func showAlert(with errorViewModel: ErrorViewModel) -> some View {
        Color.clear.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(errorViewModel.title),
                message: Text(errorViewModel.message),
                primaryButton: .default(Text("Try Again")) {
                    self.viewModel.retryLastRequest(from: errorViewModel.source)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    @ViewBuilder func gifDetailsView(from gifImageViewModel: GifImageViewModel) -> some View {
        GifDetailsView(gifImageViewModel: gifImageViewModel)
            .navigationTitle(gifImageViewModel.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
