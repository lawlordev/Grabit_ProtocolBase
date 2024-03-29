//
//  URLUtilities.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import UIKit
import PDFKit
import AVFoundation

struct URLUtilities {
    static func checkURLContentType(_ url: URL, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            let contentType = httpResponse.allHeaderFields["Content-Type"] as? String
            completion(contentType)
        }.resume()
    }
    
    static func extractImageUrl(from googleUrl: URL) -> URL? {
        let components = URLComponents(url: googleUrl, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "imgurl" })?.value.flatMap(URL.init)
    }
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    static func generatePDFThumbnail(url: URL) -> UIImage? {
        guard let pdfDocument = PDFDocument(url: url),
              let pdfPage = pdfDocument.page(at: 0) else {
            return nil
        }
        
        let pageSize = pdfPage.bounds(for: .mediaBox)
        let pdfScale = 100.0 / pageSize.width
        let scaledSize = CGSize(width: pageSize.width * pdfScale, height: pageSize.height * pdfScale)
        
        return pdfPage.thumbnail(of: scaledSize, for: .mediaBox)
    }
    
    static func generateThumbnail(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        
        assetImgGenerate.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, _ in
            if let cgImage = cgImage {
                let uiImage = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(uiImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
