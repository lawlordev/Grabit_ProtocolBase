//
//  URLPreviewViewModel.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers

final class URLPreviewViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var title: String?
    @Published var url: String?
    @Published var hasError = false
    
    private let previewURL: URL?
    private var isMetadataFetched = false
    
    init(url: URL) {
        self.previewURL = url
        fetchMetadata()
    }
    
    private func fetchMetadata() {
            guard let previewURL = previewURL, !isMetadataFetched else { return }
            isMetadataFetched = true
            
            let provider = LPMetadataProvider()
            
            Task {
                do {
                    let metadata = try await provider.startFetchingMetadata(for: previewURL)
                    let image = try? await convertToImage(metadata.imageProvider)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                        self?.title = metadata.title
                        self?.url = metadata.url?.host
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        print("Error fetching metadata: \(error)")
                        self?.hasError = true
                    }
                }
            }
        }
    
    private func convertToImage(_ imageProvider: NSItemProvider?) async throws -> UIImage? {
        guard let imageProvider = imageProvider else { return nil }
        let type = String(describing: UTType.image)
        
        if imageProvider.hasItemConformingToTypeIdentifier(type) {
            let item = try await imageProvider.loadItem(forTypeIdentifier: type)
            
            if let item = item as? UIImage {
                return item
            } else if let url = item as? URL, let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            } else if let data = item as? Data {
                return UIImage(data: data)
            }
        }
        
        return nil
    }
}
