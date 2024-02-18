//
//  removeItem.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func removeItem(with id: UUID) {
        // Find the item in Core Data
        let items = CoreDataStack.shared.fetchItems(for: board)
        if let itemToRemove = items.first(where: { $0.id == id }) {
            // Delete from Core Data
            CoreDataStack.shared.deleteItem(itemToRemove)
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        }

        // Remove the item from the local droppedItems array using the item's UUID
        droppedItems.removeAll { $0.id == id }

        selectedItemId = nil
        selectionInProgress = false
        selectedItems.removeAll()
    }
}
