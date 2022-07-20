//
//  SearchBar.swift
//  PicnicRecruitmentTask
//
//  Created by Jayesh Kawli on 7/11/22.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack(spacing: Spacing.medium) {
            HStack(spacing: Spacing.medium) {
                Images.search
                    .resizable()
                    .foregroundColor(Color.black)
                    .frame(width: ImageDimensions.standardWidth, height: ImageDimensions.standardHeight, alignment: .center)
                    .padding(.leading, Spacing.medium)

                TextField("Search", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            isSearching = true
                        }
                    }
                }
                .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Images.close
                            .resizable()
                            .foregroundColor(Color.black)
                            .frame(width: ImageDimensions.standardWidth, height: ImageDimensions.standardHeight, alignment: .center)
                            .padding(.trailing, Spacing.medium)
                    }
                }
            }
            .padding(.vertical, Spacing.small)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(CornerRadius.medium)
            
            if isSearching {
                Button("Cancel") {
                    searchText = ""
                    withAnimation {
                        isSearching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                }
                .foregroundColor(Color.black)
            }
        }.padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var searchText = ""
    @State static var isSearching = false
    
    static var previews: some View {
        SearchBar(searchText: $searchText, isSearching: $isSearching)
    }
}
