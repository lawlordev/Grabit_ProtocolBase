//
//  removeItem.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func removeItem(with id: UUID) {
        // Find the index of the item with the given id
        if let index = droppedItems.firstIndex(where: { $0.id == id }) {
            droppedItems.remove(at: index)

            // Update selectedItems indices since droppedItems has changed
            selectedItems = Set(selectedItems.map { $0 > index ? $0 - 1 : $0 }.filter { $0 != index })
        }
    }
}
