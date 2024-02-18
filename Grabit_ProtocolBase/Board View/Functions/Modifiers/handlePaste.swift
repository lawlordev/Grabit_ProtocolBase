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
        print("Pasteboard types: \(pasteboard.types)")
        
        // Check for specific file types in the pasteboard
        if pasteboard.types.contains("com.adobe.pdf") {
            handlePDFData(pasteboard)
        } else if pasteboard.types.contains("public.mpeg-4") {
            handleVideoData(pasteboard, type: "public.mpeg-4")
        } else if pasteboard.types.contains("com.apple.quicktime-movie") {
            handleVideoData(pasteboard, type: "com.apple.quicktime-movie")
        } else if let url = pasteboard.url {
            processURL(url)
        } else if let string = pasteboard.string {
            handlePlainText(text: string)
        } else if let image = pasteboard.image {
            let imageItem = ImageItem(image: image)
            addItem(imageItem)
        }
        
        UIPasteboard.general.items = []
    }
    
    private func processURL(_ url: URL) {
        switch url.pathExtension.lowercased() {
        case "pdf":
            handlePDF(url)
        case "mp4", "mov", "avi", "m4v":
            handleVideo(url: url)
        default:
            handleURL(url)
        }
    }
    
    private func handlePDFData(_ pasteboard: UIPasteboard) {
        guard let pdfData = pasteboard.data(forPasteboardType: "com.adobe.pdf") else { return }
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let tempURL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
        
        do {
            try pdfData.write(to: tempURL)
            handlePDF(tempURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                try? fileManager.removeItem(at: tempURL)
            }
        } catch {
            print("Error saving PDF data: \(error)")
        }
    }
    
    private func handleVideoData(_ pasteboard: UIPasteboard, type: String) {
        guard let videoData = pasteboard.data(forPasteboardType: type) else { return }
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileExtension = (type == "public.mpeg-4") ? "mp4" : "mov"
        let tempURL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".\(fileExtension)")
        
        do {
            try videoData.write(to: tempURL)
            handleVideo(url: tempURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                try? fileManager.removeItem(at: tempURL)
            }
        } catch {
            print("Error saving video data: \(error)")
        }
    }
}
