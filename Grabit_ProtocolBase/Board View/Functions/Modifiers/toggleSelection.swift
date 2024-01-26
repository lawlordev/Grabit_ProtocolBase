//
//  toggleSelection.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func toggleSelection(for index: Int) {
        if selectedItemIndex == index {
            showingOrnament = false
            selectedItemIndex = nil
        } else {
            selectedItemIndex = index
            showingOrnament = true
        }
    }
}
