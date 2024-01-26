//
//  handlePDF.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation
import UniformTypeIdentifiers

extension BoardView {
    func handlePDF(_ url: URL) {
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                if let localUrl = self.copyToTemporaryLocation(originalURL: url) {
                    if let thumbnail = URLUtilities.generatePDFThumbnail(url: localUrl) {
                        let title = localUrl.deletingPathExtension().lastPathComponent
                        self.addItem(PDFItem(url: localUrl, title: title, thumbnail: thumbnail))
                    }
                }
            }
        }
    
    func copyToTemporaryLocation(originalURL: URL) -> URL? {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let tempURL = tempDirectory.appendingPathComponent(originalURL.lastPathComponent)
        
        // Start accessing the security-scoped resource
        guard originalURL.startAccessingSecurityScopedResource() else {
            return nil
        }

        defer {
            // Make sure to stop accessing the security-scoped resource
            originalURL.stopAccessingSecurityScopedResource()
        }

        do {
            if fileManager.fileExists(atPath: tempURL.path) {
                try fileManager.removeItem(at: tempURL)
            }
            try fileManager.copyItem(at: originalURL, to: tempURL)
            return tempURL
        } catch {
            print("Failed to copy file: \(error)")
            return nil
        }
    }
    
    func downloadAndStorePDF(from url: URL, completion: @escaping (URL?) -> Void) {
            let downloadTask = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
                guard let tempLocalUrl = tempLocalUrl, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                let fileManager = FileManager.default
                let tempDirectory = fileManager.temporaryDirectory
                let tempURL = tempDirectory.appendingPathComponent(url.lastPathComponent)

                do {
                    if fileManager.fileExists(atPath: tempURL.path) {
                        try fileManager.removeItem(at: tempURL)
                    }
                    try fileManager.moveItem(at: tempLocalUrl, to: tempURL)
                    DispatchQueue.main.async {
                        completion(tempURL)
                    }
                } catch {
                    print("Failed to move file: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }

            downloadTask.resume()
        }
}
