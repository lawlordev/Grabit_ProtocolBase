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
            .overlay(
                selectionInProgress ? selectionIndicator(isSelected: selectedItems.contains(index)) : nil
            )
            .onTapGesture {
                if selectionInProgress {
                    if selectedItems.contains(index) {
                        selectedItems.remove(index)
                    } else {
                        selectedItems.insert(index)
                    }
                } else {
                    toggleSelection(for: index)
                }
            }
            .onDrag {
                self.draggingItemID = item.id
                return handleDragAway(for: item, at: index)
            }
    }
    
    private func selectionIndicator(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .strokeBorder(Color.black, lineWidth: 2)
                .background(Circle().fill(isSelected ? Color.black : Color.clear))
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
        }
        .frame(width: 30, height: 30)
        .padding()
    }
}
