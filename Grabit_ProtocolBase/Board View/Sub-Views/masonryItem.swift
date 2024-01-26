//
//  masonryItem.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func masonryItem(for item: any DroppableItem, at index: Int) -> some View {
        item.view(contentView: self)
            .frame(width: minimumItemDimensions)
            .background(materialBackground(isSelected: selectedItemIndex == index))
            .onTapGesture {
                toggleSelection(for: index)
            }
            .onDrag {
                handleDragAway(for: item, at: index)
            }
    }
}
