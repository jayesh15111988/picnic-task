//
//  PicnicRecruitmentTaskApp.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI

@main
struct PicnicRecruitmentTaskApp: App {
    var body: some Scene {
        WindowGroup {
        
            let networkService = NetworkServiceImpl()
            let viewModel = HomeScreenViewModel(networkService: networkService)
            
            HomeScreenView(viewModel: viewModel)
        }
    }
}
