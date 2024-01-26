//
//  Protocol.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

protocol DroppableItem: Equatable {
    func view(contentView: BoardView) -> AnyView
}

struct TextItem: DroppableItem {
    let text: String

    func view(contentView: BoardView) -> AnyView {
        AnyView(Text(text).padding())
    }
}

struct URLItem: DroppableItem {
    let url: URL

    func view(contentView: BoardView) -> AnyView {
        AnyView(CustomURLPreviewView(viewModel: contentView.createViewModel(for: url)).cornerRadius(16))
    }
}

struct ImageItem: DroppableItem {
    let image: UIImage

    func view(contentView: BoardView) -> AnyView {
        AnyView(Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).cornerRadius(16))
    }
}

struct PDFItem: DroppableItem {
    let url: URL
    let title: String
    let thumbnail: UIImage

    func view(contentView: BoardView) -> AnyView {
        AnyView(PDFPreviewView(url: url, title: title, thumbnail: thumbnail))
    }
}
