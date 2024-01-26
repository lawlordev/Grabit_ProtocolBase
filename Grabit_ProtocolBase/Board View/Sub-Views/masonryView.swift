//
//  masonryView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import SwiftUIMasonry

extension BoardView {
    func masonryView(for geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let numberOfColumns = max(2, Int(width / (minimumItemDimensions + 10)))
        
        return VMasonry(columns: numberOfColumns) {
            ForEach(droppedItems, id: \.id) { item in
                if let index = droppedItems.firstIndex(where: { $0.id == item.id }) {
                    masonryItem(for: item, at: index)
                }
            }
        }
        .padding()
        .animation(.easeInOut, value: droppedItems.map { $0.id })
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            itemActionsView
        })
    }
}
