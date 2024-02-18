//
//  itemActionsView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import QuickLook

extension BoardView {
    @ViewBuilder
    var itemActionsView: some View {
        if let selectedId = selectedItemId, let item = droppedItems.first(where: { $0.id == selectedId }) {
            HStack {
                if let textItem = item as? TextItem {
                    Button(action: { copy(textItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy")
                    .glassBackgroundEffect()
                    
                } else if let urlItem = item as? URLItem {
                    Button(action: { copy(urlItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy")
                    .glassBackgroundEffect()
                    
                    Button(action: { navigateToURL(urlItem.url) }) {
                        Image(systemName: "safari")
                    }
                    .help("Open")
                    .glassBackgroundEffect()
                    
                } else if let imageItem = item as? ImageItem {
                    Button(action: { copy(imageItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy")
                    .glassBackgroundEffect()
                    
                } else if let pdfItem = item as? PDFItem {
                    Button(action: { copy(pdfItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy")
                    .glassBackgroundEffect()
                } else if let videoItem = item as? VideoItem {
                    Button(action: { copy(videoItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("Copy")
                    .glassBackgroundEffect()
                }
                
                Button(action: { toggleFavorite(for: item) }) {
                    Image(systemName: item.favorite ? "star.fill" : "star")
                        .foregroundStyle(item.favorite ? Color.yellow : Color.white)
                }
                .help("Favorite")
                .glassBackgroundEffect()
                
                Button(action: { removeItem(with: item.id)} ) {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                }
                .help("Delete")
                .glassBackgroundEffect()
            }
            .opacity(showingOrnament ? 1.0 : 0.0)
        } else {
            EmptyView()
        }
    }
    
    private func toggleFavorite(for item: any DroppableItem) {
        CoreDataStack.shared.toggleFavoriteItem(byId: item.id)
        refreshBoard()
    }
}
