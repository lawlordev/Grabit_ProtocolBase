//
//  CustomVideoPlayerView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/27/24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: View {
    let url: URL
    @State private var thumbnailImage: UIImage?

    var body: some View {
        Group {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            if url.isFileURL {
                URLUtilities.generateThumbnail(for: url) { thumbnailImage in
                    self.thumbnailImage = thumbnailImage
                    print("DEBUG: Thumbnail generated for local file.")
                }
            } else {
                VideoDownloadManager().downloadVideo(from: url) { downloadedUrl in
                    if let downloadedUrl = downloadedUrl {
                        URLUtilities.generateThumbnail(for: downloadedUrl) { thumbnailImage in
                            self.thumbnailImage = thumbnailImage
                            print("DEBUG: Thumbnail generated for downloaded video.")
                        }
                    } else {
                        print("DEBUG: Video download failed or no thumbnail generated.")
                        // Handle download failure or no thumbnail case
                    }
                }
            }
        }
        .cornerRadius(16)
    }
}

