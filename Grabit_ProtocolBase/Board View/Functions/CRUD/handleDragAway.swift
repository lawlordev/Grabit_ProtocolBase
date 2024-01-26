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
        
        selectedItemIndex = nil
        showingOrnament = false
        
        return itemProvider
    }
}
