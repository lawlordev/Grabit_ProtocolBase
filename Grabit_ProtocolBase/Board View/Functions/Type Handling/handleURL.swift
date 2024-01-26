//
//  handleURL.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func handleURL(_ url: URL) {
        // Special case for PDF URLs
        if url.pathExtension.lowercased() == "pdf" {
            handlePDFURL(url)
        }
        // Case for direct image URLs
        else if let directImageUrl = URLUtilities.extractImageUrl(from: url) {
            handleDirectImageURL(directImageUrl)
        }
        // Default case: check content type of URL
        else {
            handleURLContentType(url)
        }
    }

    private func handlePDFURL(_ url: URL) {
        if let thumbnail = URLUtilities.generatePDFThumbnail(url: url) {
            let title = url.deletingPathExtension().lastPathComponent
            DispatchQueue.main.async {
                self.addItem(PDFItem(url: url, title: title, thumbnail: thumbnail))
            }
        }
    }

    private func handleDirectImageURL(_ url: URL) {
        DispatchQueue.main.async {
            URLUtilities.loadImage(from: url) { image in
                if let image = image {
                    self.addItem(ImageItem(image: image))
                } else {
                    // Handle the case where the image couldn't be loaded
                }
            }
        }
    }

    private func handleURLContentType(_ url: URL) {
        URLUtilities.checkURLContentType(url) { contentType in
            DispatchQueue.global(qos: .userInitiated).async {
                if let contentType = contentType, contentType.contains("image") {
                    self.loadAndHandleImage(url)
                } else {
                    self.addURLItem(url)
                }
            }
        }
    }

    private func loadAndHandleImage(_ url: URL) {
        URLUtilities.loadImage(from: url) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.addItem(ImageItem(image: image))
                } else {
                    // Handle the case where the image couldn't be loaded
                }
            }
        }
    }

    private func addURLItem(_ url: URL) {
        DispatchQueue.main.async {
            if self.viewModelCache[url] == nil {
                self.viewModelCache[url] = URLPreviewViewModel(url: url)
            }
            self.addItem(URLItem(url: url))
        }
    }
}
