//
//  removeItem.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func removeItem(at index: Int) {
        guard index >= 0 && index < droppedItems.count else {
            // Optionally, log an error message or handle the invalid index appropriately
            return
        }
        droppedItems.remove(at: index)
    }
}
