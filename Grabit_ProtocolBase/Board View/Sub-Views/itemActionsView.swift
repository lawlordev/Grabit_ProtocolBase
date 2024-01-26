//
//  itemActionsView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    @ViewBuilder
    var itemActionsView: some View {
        if let selectedItemIndex = selectedItemIndex, selectedItemIndex < droppedItems.count {
            let item = droppedItems[selectedItemIndex]
            
            HStack {
                if let textItem = item as? TextItem {
                    Button(action: { copy(textItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                } else if let urlItem = item as? URLItem {
                    Button(action: { copy(urlItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                    Button(action: { navigateToURL(urlItem.url) }) {
                        Image(systemName: "safari")
                    }
                } else if let imageItem = item as? ImageItem {
                    Button(action: {
                        removeBackgroundFromImage(at: selectedItemIndex)
                    }) {
                        Image(systemName: "wand.and.stars")
                    }
                    Button(action: { copy(imageItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                } else if let pdfItem = item as? PDFItem {
                    Button(action: { copy(pdfItem) }) {
                        Image(systemName: "doc.on.doc")
                    }
                }
                
                Button(action: { removeItem(with: item.id)} ) {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                }
            }
            .font(.title)
            .padding()
            .opacity(showingOrnament ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.5), value: showingOrnament)
            .glassBackgroundEffect()
        } else {
            EmptyView()
        }
    }
}
