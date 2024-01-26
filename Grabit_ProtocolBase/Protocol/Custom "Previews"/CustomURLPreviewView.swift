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
            } else if viewModel.hasError {
                // Display an error message
                VStack {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("Error loading this website's data")
                }
                .frame(width: 150, height: 150)
            } else {
                // Placeholder image or view if no image is available
                ProgressView()
                    .frame(width: 150, height: 150)
            }
            if let title = viewModel.title {
                Text(title)
                    .font(.callout)
                    .padding(.horizontal)
            }
            if let url = viewModel.url {
                Text(url)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
}
