//
//  CustomURLPreviewView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

struct CustomURLPreviewView: View {
    @ObservedObject var viewModel: URLPreviewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if viewModel.isLoading {
                // Display progress view while loading
                ProgressView()
                    .frame(width: 150, height: 150)
            } else if viewModel.hasError {
                // Display error message
                VStack {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("Error loading this website's data")
                }
                .frame(width: 150, height: 150)
            }
            // Text views for title and URL
            if let title = viewModel.title {
                Text(title)
                    .font(.callout)
                    .padding(.horizontal, 12)
            }
            if let url = viewModel.url {
                Text(url)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
        }
    }
}
