//
//  handlePlainText.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func handlePlainText(text: String) {
        if let url = URL(string: text), UIApplication.shared.canOpenURL(url) {
            if url.pathExtension.lowercased() == "rtf" || url.pathExtension.lowercased() == "rtfd" {
                // Handle RTF and RTFD files
                handleRTFFile(url)
            } else {
                // Handle regular URLs
                handleURL(url)
            }
        } else {
            let textItem = TextItem(text: text)
            addItem(textItem)
            
            // Save to Core Data
            if let encodedData = CoreDataStack.shared.encodeDroppableItem(textItem) {
                CoreDataStack.shared.addItem(to: board, id: textItem.id, type: "TextItem", data: encodedData)
            }
        }
    }
    
    func handleRTFFile(_ url: URL) {
        let documentType: NSAttributedString.DocumentType = url.pathExtension.lowercased() == "rtfd" ? .rtfd : .rtf
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: documentType]
        
        do {
            let attributedString = try NSAttributedString(url: url, options: options, documentAttributes: nil)
            let plainText = attributedString.string
            let textItem = TextItem(text: plainText)
            addItem(textItem)
            
            // Save to Core Data
            if let encodedData = CoreDataStack.shared.encodeDroppableItem(textItem) {
                CoreDataStack.shared.addItem(to: board, id: textItem.id, type: "TextItem", data: encodedData)
            }
        } catch {
            print("Error reading RTF file: \(error)")
            // Handle the error or add a fallback mechanism
        }
    }
}

