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
            if let pngData = imageItem.image.pngData() {
                itemProvider.registerDataRepresentation(forTypeIdentifier: UTType.png.identifier, visibility: .all) { completion in
                    completion(pngData, nil)
                    return nil
                }
            }
            return itemProvider

        case let pdfItem as PDFItem:
                    let itemProvider = NSItemProvider()

                    if pdfItem.url.isFileURL {
                        // Local file URL case
                        itemProvider.registerFileRepresentation(forTypeIdentifier: UTType.pdf.identifier, fileOptions: [], visibility: .all) { completion in
                            completion(pdfItem.url, true, nil)
                            return nil
                        }
                    } else {
                        // Remote URL case
                        downloadAndStorePDF(from: pdfItem.url) { localUrl in
                            if let localUrl = localUrl {
                                itemProvider.registerFileRepresentation(forTypeIdentifier: UTType.pdf.identifier, fileOptions: [], visibility: .all) { completion in
                                    completion(localUrl, true, nil)
                                    return nil
                                }
                            }
                        }
                    }
                    return itemProvider

        default:
            fatalError("Unsupported item type")
        }
    }
}
