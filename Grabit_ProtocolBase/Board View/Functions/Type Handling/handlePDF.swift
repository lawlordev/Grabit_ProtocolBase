//
//  handlePDF.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation
import UniformTypeIdentifiers

extension BoardView {
    // Handle both local and web PDF URLs
    func handlePDF(_ url: URL) {
        if url.isFileURL {
            copyPDFToAppDirectory(originalURL: url) { copiedURL in
                guard let copiedURL = copiedURL else {
                    // Handle the error
                    return
                }
                self.processPDF(copiedURL)
            }
        } else {
            downloadPDF(from: url) { downloadedURL in
                guard let downloadedURL = downloadedURL else {
                    // Handle the error
                    return
                }
                self.processPDF(downloadedURL)
            }
        }
    }
    
    // This method will be similar to `copyVideoToAppDirectory` in your video handling code
    func copyPDFToAppDirectory(originalURL: URL, completion: @escaping (URL?) -> Void) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(UUID().uuidString + "." + originalURL.pathExtension)

        let fileCoordinator = NSFileCoordinator()
        var coordinationError: NSError?
        fileCoordinator.coordinate(readingItemAt: originalURL, options: [], error: &coordinationError) { (newURL) in
            do {
                let success = originalURL.startAccessingSecurityScopedResource()
                defer { originalURL.stopAccessingSecurityScopedResource() }
                if success {
                    if fileManager.fileExists(atPath: destinationURL.path) {
                        completion(destinationURL)
                        return
                    }

                    try fileManager.copyItem(at: originalURL, to: destinationURL)
                    completion(destinationURL)
                } else {
                    print("Failed to access the original file.")
                    completion(nil)
                }
            } catch {
                print("Error copying file: \(error)")
                completion(nil)
            }
        }

        if let error = coordinationError {
            print("File coordination error: \(error)")
            completion(nil)
        }
    }
    
    func processPDF(_ url: URL) {
        DispatchQueue.main.async {
            if let thumbnail = URLUtilities.generatePDFThumbnail(url: url) {
                let title = url.deletingPathExtension().lastPathComponent
                let relativePath = url.lastPathComponent // Store only the file name
                let pdfItem = PDFItem(relativePath: relativePath, title: title, thumbnail: thumbnail) // Adjust PDFItem initialization accordingly
                self.addItem(pdfItem)
                print("DEBUG: Added PDF to items")

                // Save to Core Data
                if let encodedData = CoreDataStack.shared.encodeDroppableItem(pdfItem) {
                    CoreDataStack.shared.addItem(to: board, id: pdfItem.id, type: "PDFItem", data: encodedData)
                    print("DEBUG: Saved PDF to CoreData")
                }
            }
        }
    }
    
    // Download PDF from a web URL
    func downloadPDF(from url: URL, completion: @escaping (URL?) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let tempLocalURL = localURL, error == nil else {
                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or status code")
                completion(nil)
                return
            }
            
            // Generate a permanent URL with a unique filename for the PDF
            let permanentURL = self.getPermanentPDFURL(from: tempLocalURL)
            
            do {
                // Move the file from the temp location to the permanent location
                try FileManager.default.moveItem(at: tempLocalURL, to: permanentURL)
                completion(permanentURL)
            } catch {
                print("Failed to move file to permanent location: \(error)")
                completion(nil)
            }
        }
        downloadTask.resume()
    }
    
    // Generate a permanent URL with a unique filename for the PDF
    func getPermanentPDFURL(from tempURL: URL) -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
        
        return destinationURL
    }
}
