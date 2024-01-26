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

        case let urlItem as URLItem:
            pasteboard.string = urlItem.url.absoluteString

        case let imageItem as ImageItem:
            pasteboard.image = imageItem.image

        case let pdfItem as PDFItem:
            // For PDF, we want to copy the file itself
            let itemProvider = NSItemProvider(contentsOf: pdfItem.url)!
            pasteboard.setItemProviders([itemProvider], localOnly: true, expirationDate: nil)

        default:
            print("Unsupported type for copying")
        }
    }
}
