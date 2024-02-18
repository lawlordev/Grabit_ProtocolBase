//
//  handleURL.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func handleURL(_ url: URL) {
        let videoExtensions = ["mov", "mp4", "avi", "m4v"]
        
        // Special case for PDF URLs
        if url.pathExtension.lowercased() == "pdf" {
            handlePDF(url)
        }
        // Case for direct image URLs
        else if let directImageUrl = URLUtilities.extractImageUrl(from: url) {
            handleDirectImageURL(directImageUrl)
        } else if videoExtensions.contains(url.pathExtension.lowercased()) {
            handleVideo(url: url)
        } else {
            handleURLContentType(url)
        }
    }
    
    private func handleDirectImageURL(_ url: URL) {
        DispatchQueue.main.async {
            URLUtilities.loadImage(from: url) { image in
                if let image = image {
                    let imageItem = ImageItem(image: image)
                    self.addItem(imageItem)
                    
                    // Save to Core Data
                    if let encodedData = CoreDataStack.shared.encodeDroppableItem(imageItem) {
                        CoreDataStack.shared.addItem(to: board, id: imageItem.id, type: "ImageItem", data: encodedData)
                    }
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
                    let imageItem = ImageItem(image: image)
                    self.addItem(imageItem)
                    
                    // Save to Core Data
                    if let encodedData = CoreDataStack.shared.encodeDroppableItem(imageItem) {
                        CoreDataStack.shared.addItem(to: board, id: imageItem.id, type: "ImageItem", data: encodedData)
                    }
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
            
            let urlItem = URLItem(url: url)
            self.addItem(urlItem)
            
            // Save to Core Data
            if let encodedData = CoreDataStack.shared.encodeDroppableItem(urlItem) {
                CoreDataStack.shared.addItem(to: board, id: urlItem.id, type: "URLItem", data: encodedData)
            }
        }
    }
}
