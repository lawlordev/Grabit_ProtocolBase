//
//  handlePaste.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func handlePaste() {
        let pasteboard = UIPasteboard.general
        
        if let url = pasteboard.url {
            if url.pathExtension.lowercased() == "pdf" {
                // Handling both local and remote PDF URLs
                handlePDFURL(url)
            } else {
                // Handling other types of URLs
                handleURL(url)
            }
        } else if let string = pasteboard.string {
            // Handling plain text
            handlePlainText(text: string)
        } else if let image = pasteboard.image {
            // Handling an image
            let imageItem = ImageItem(image: image)
            addItem(imageItem)
        }
        
        UIPasteboard.general.items = []
    }
    
    private func handlePDFURL(_ url: URL) {
        if url.isFileURL {
            // Handling a local PDF file
            handlePDFPaste(url)
        } else {
            // Handling a remote PDF URL
            downloadAndStorePDF(from: url) { downloadedUrl in
                DispatchQueue.main.async {
                    if let downloadedUrl = downloadedUrl {
                        self.handlePDFPaste(downloadedUrl)
                    } else {
                        // Handle error: unable to download or store the PDF
                    }
                }
            }
        }
    }
    
    private func handlePDFPaste(_ url: URL) {
        if let thumbnail = URLUtilities.generatePDFThumbnail(url: url) {
            let title = url.deletingPathExtension().lastPathComponent
            let pdfItem = PDFItem(url: url, title: title, thumbnail: thumbnail)
            addItem(pdfItem)
        }
    }
}
