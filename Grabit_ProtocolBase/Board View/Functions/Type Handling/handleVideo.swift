//
//  handleVideo.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/27/24.
//

import Foundation

extension BoardView {
    func handleVideo(url: URL) {
            // Determine if the URL is a local file and needs to be copied
            if url.isFileURL {
                copyVideoToAppDirectory(originalURL: url) { copiedURL in
                    guard let copiedURL = copiedURL else {
                        // Handle the error (e.g., show an alert)
                        return
                    }
                    self.processVideo(copiedURL)
                }
            } else {
                // Download and process external URLs
                let videoManager = VideoDownloadManager()
                videoManager.downloadVideo(from: url) { downloadedUrl in
                    guard let downloadedUrl = downloadedUrl else {
                        // Handle the error
                        return
                    }
                    self.processVideo(downloadedUrl)
                }
            }
        }
    
    func processVideo(_ url: URL) {
        DispatchQueue.main.async {
            let relativePath = url.lastPathComponent
            let videoItem = VideoItem(relativePath: relativePath)
            self.addItem(videoItem)
            
            // Save to Core Data
            if let encodedData = CoreDataStack.shared.encodeDroppableItem(videoItem) {
                CoreDataStack.shared.addItem(to: self.board, id: videoItem.id, type: "VideoItem", data: encodedData)
                print("DEBUG: Video successfully encoded!")
            }
        }
    }
    
    func copyVideoToAppDirectory(originalURL: URL, completion: @escaping (URL?) -> Void) {
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
}
