//
//  addItem.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func addItem(_ newItem: any DroppableItem) {
        droppedItems.insert(newItem, at: 0)
    }
}
