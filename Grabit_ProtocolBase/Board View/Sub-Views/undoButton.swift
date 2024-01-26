//
//  undoButton.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    var undoButton: some View {
        Button(action: { undoLastRemoval() }) {
            Image(systemName: "arrow.uturn.backward")
        }
        .font(.title)
        .padding()
        .animation(.easeInOut(duration: 0.5), value: showUndoButton)
    }
}

extension BoardView {
    func undoLastRemoval() {
        guard let lastAction = lastAction else { return }

        switch lastAction.actionType {
        case .removal:
            droppedItems.insert(lastAction.originalItem, at: lastAction.index)
        case .edit:
            droppedItems[lastAction.index] = lastAction.originalItem
        }

        self.lastAction = nil
        showUndoButton = false
    }
}

enum UndoActionType {
    case removal
    case edit
}

struct LastAction {
    let actionType: UndoActionType
    let originalItem: any DroppableItem
    let index: Int
}
