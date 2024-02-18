//
//  copy.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func copy(_ item: any DroppableItem) {
        let pasteboard = UIPasteboard.general
        pasteboard.items = [] // Clear existing items
        
        switch item {
        case let textItem as TextItem:
            pasteboard.string = textItem.text
            justCopied = true
            
        case let urlItem as URLItem:
            pasteboard.string = urlItem.url.absoluteString
            justCopied = true
            
        case let imageItem as ImageItem:
            pasteboard.image = imageItem.image
            justCopied = true
            
        case let pdfItem as PDFItem:
            // For PDF, we want to copy the file itself
            if let itemProvider = NSItemProvider(contentsOf: pdfItem.url) {
                pasteboard.setItemProviders([itemProvider], localOnly: true, expirationDate: nil)
                justCopied = true
            }
            
        case let videoItem as VideoItem:
            // For Video, copy the file itself
            if let itemProvider = NSItemProvider(contentsOf: videoItem.url) {
                pasteboard.setItemProviders([itemProvider], localOnly: true, expirationDate: nil)
                justCopied = true
            }
            
        default:
            print("Unsupported type for copying")
        }
    }
}
