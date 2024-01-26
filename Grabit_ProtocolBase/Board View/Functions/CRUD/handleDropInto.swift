//
//  handleDropInto.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension BoardView {
    func handleDropInto(providers: [NSItemProvider]) -> Bool {
        guard draggingItemID == nil else {
            // This is an internal drag, so don't add a new item
            return false
        }
        
        var didHandle = false
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                _ = provider.loadObject(ofClass: String.self) { string, _ in
                    DispatchQueue.main.async {
                        if let string = string {
                            self.handlePlainText(text: string)
                            didHandle = true
                        }
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                _ = provider.loadObject(ofClass: URL.self) { url, _ in
                    DispatchQueue.main.async {
                        if let url = url {
                            self.handleURL(url)
                            didHandle = true
                        }
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                _ = provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.handleImage(image: image)
                            didHandle = true
                        }
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { (item, error) in
                    DispatchQueue.main.async {
                        if let url = item as? URL {
                            self.handlePDF(url)
                            didHandle = true
                        }
                    }
                }
            }
        }
        
        return didHandle
    }
}
