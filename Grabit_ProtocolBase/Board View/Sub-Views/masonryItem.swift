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
            .background(materialBackground())
            .overlay(
                selectionInProgress ? selectionIndicator(isSelected: selectedItems.contains(item.id)) : nil
            )
            .scaleEffect(selectedItemId == item.id ? 1.1 : 1.0)
            .onTapGesture {
                withAnimation(.interactiveSpring) {
                    if selectionInProgress {
                        let itemID = item.id
                        if selectedItems.contains(itemID) {
                            selectedItems.removeAll(where: { $0 == itemID })
                        } else {
                            selectedItems.append(itemID)
                        }
                    } else {
                        toggleSelection(for: item.id)
                    }
                }
            }
            .onDrag {
                self.draggingItemID = item.id
                return handleDragAway(for: item, at: index)
            }
    }
    
    
    private func selectionIndicator(isSelected: Bool) -> some View {
        HStack {
            Spacer()
            
            VStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .background(Circle().fill(isSelected ? Color.blue : Color.clear))
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 30, height: 30)
                .padding(12)
                
                Spacer()
            }
        }
    }
}
