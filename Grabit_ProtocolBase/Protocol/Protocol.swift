//
//  Protocol.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

protocol DroppableItem {
    var id: UUID { get }
    var favorite: Bool { get set }
    func view(contentView: BoardView) -> AnyView
}

struct TextItem: DroppableItem, Codable {
    var id = UUID()
    var favorite: Bool = false // Default value
    let text: String
    
    func view(contentView: BoardView) -> AnyView {
        AnyView(Text(text).padding())
    }
}

struct URLItem: DroppableItem, Codable {
    var id = UUID()
    var favorite: Bool = false // Default value
    var url: URL
    
    func view(contentView: BoardView) -> AnyView {
        AnyView(CustomURLPreviewView(viewModel: contentView.createViewModel(for: url)).cornerRadius(16))
    }
}

struct ImageItem: DroppableItem, Codable {
    var id = UUID()
    var favorite: Bool = false // Default value
    var imageData: Data?
    
    init(image: UIImage) {
        self.imageData = image.pngData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, imageData
    }
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
    
    func view(contentView: BoardView) -> AnyView {
        if let uiImage = self.image {
            return AnyView(Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit).cornerRadius(16))
        }
        return AnyView(EmptyView())
    }
}

struct PDFItem: DroppableItem, Codable {
    var id = UUID()
    var favorite: Bool = false
    var relativePath: String
    var title: String
    var thumbnailData: Data?
    
    // Initialize with a relative path, title, and thumbnail
    init(relativePath: String, title: String, thumbnail: UIImage) {
        self.relativePath = relativePath
        self.title = title
        self.thumbnailData = thumbnail.pngData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, relativePath, title, thumbnailData
    }
    
    // Construct the full URL from the relative path when needed
    var url: URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsDirectory?.appendingPathComponent(relativePath)
    }
    
    var thumbnail: UIImage? {
        if let data = thumbnailData {
            return UIImage(data: data)
        }
        return nil
    }
    
    func view(contentView: BoardView) -> AnyView {
        if let thumbnailImage = self.thumbnail, let url = self.url {
            return AnyView(PDFPreviewView(url: url, title: title, thumbnail: thumbnailImage).cornerRadius(16))
        }
        return AnyView(EmptyView())
    }
}

struct VideoItem: DroppableItem, Codable {
    var id = UUID()
    var favorite: Bool = false // Default value
    var relativePath: String
    
    var url: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(relativePath)
    }
    
    func view(contentView: BoardView) -> AnyView {
        AnyView(CustomVideoPlayerView(url: self.url))
    }
}

