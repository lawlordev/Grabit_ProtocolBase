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
    @Published var isLoading = true
    
    private let previewURL: URL?
    private var isMetadataFetched = false
    
    init(url: URL) {
        self.previewURL = url
        fetchFinalURL(url)
    }
    
    private func fetchFinalURL(_ url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // To reduce data usage
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let finalURL = response?.url, error == nil else {
                DispatchQueue.main.async {
                    self?.hasError = true
                }
                return
            }
            self?.fetchMetadata(finalURL)
        }.resume()
    }
    
    private func fetchMetadata(_ url: URL) {
        guard !isMetadataFetched else { return }
        isMetadataFetched = true
        
        let provider = LPMetadataProvider()
        
        Task {
            do {
                let metadata = try await provider.startFetchingMetadata(for: url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                    guard self?.isLoading == true else { return }
                    self?.image = nil
                    self?.isLoading = false
                }
                let image = try? await convertToImage(metadata.imageProvider)
                
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    self?.title = metadata.title
                    self?.url = metadata.url?.host
                    self?.isLoading = false
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    print("Error fetching metadata: \(error)")
                    self?.hasError = true
                    self?.isLoading = false
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
