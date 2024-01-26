//
//  handleDragAway.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func handleDragAway(for item: any DroppableItem, at index: Int) -> NSItemProvider {
        let itemProvider = createItemProvider(for: item)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if !droppedItems.isEmpty {
                lastAction = LastAction(actionType: .removal, originalItem: item, index: index)
                showUndoButton = true
                removeItem(at: index)
                selectedItemIndex = nil
                showingOrnament = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if showUndoButton {
                showUndoButton = false
                lastAction = nil
            }
        }
        
        return itemProvider
    }
}
