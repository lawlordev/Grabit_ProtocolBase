//
//  VideoDownloadManager.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/27/24.
//

import Foundation

class VideoDownloadManager: ObservableObject {
    func downloadVideo(from url: URL, completion: @escaping (URL?) -> Void) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(UUID().uuidString + "." + url.pathExtension)

        if fileManager.fileExists(atPath: destinationURL.path) {
            completion(destinationURL)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                print("DEBUG: There was an error downloading the video.")
                return
            }
            
            do {
                try fileManager.moveItem(at: tempURL, to: destinationURL)
                DispatchQueue.main.async { completion(destinationURL) }
                print("DEBUG: Saved video successfully!")
            } catch {
                print("DEBUG: Error saving downloaded video: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }
        task.resume()
    }
}

