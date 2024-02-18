//
//  createItemProvider.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation
import UniformTypeIdentifiers

extension BoardView {
    func createItemProvider(for item: any DroppableItem) -> NSItemProvider {
        switch item {
        case let textItem as TextItem:
            return NSItemProvider(object: textItem.text as NSString)
            
        case let urlItem as URLItem:
            return NSItemProvider(object: urlItem.url as NSURL)
            
        case let imageItem as ImageItem:
            let itemProvider = NSItemProvider()
            if let imageData = imageItem.imageData {
                itemProvider.registerDataRepresentation(forTypeIdentifier: UTType.png.identifier, visibility: .all) { completion in
                    completion(imageData, nil)
                    return nil
                }
            }
            return itemProvider
            
        case let pdfItem as PDFItem:
            let itemProvider = NSItemProvider()
            if let url = pdfItem.url {
                // Directly use the existing URL of the PDFItem
                itemProvider.registerFileRepresentation(forTypeIdentifier: UTType.pdf.identifier, fileOptions: [], visibility: .all) { completion in
                    completion(url, true, nil)
                    return nil
                }
            } else {
                print("PDFItem does not have a valid URL")
            }
            return itemProvider
            
        case let videoItem as VideoItem:
            let itemProvider = NSItemProvider(contentsOf: videoItem.url)
            return itemProvider ?? NSItemProvider()
            
        default:
            fatalError("Unsupported item type")
        }
    }
}

