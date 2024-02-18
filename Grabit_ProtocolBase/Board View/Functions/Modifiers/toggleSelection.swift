//
//  toggleSelection.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func toggleSelection(for id: UUID) {
        if selectedItemId == id {
            showingOrnament = false
            selectedItemId = nil
        } else {
            selectedItemId = id
            showingOrnament = true
        }
    }
}
