//
//  BoardViewModel.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/29/24.
//

import SwiftUI

class BoardViewModel: ObservableObject {
    private var board: Board

    @Published var name: String {
        didSet {
            board.name = name
            save()
        }
    }

    @Published var color: UIColor {
        didSet {
            board.color = color.toData()
            save()
        }
    }

    init(board: Board) {
        self.board = board
        self.name = board.name ?? ""
        self.color = UIColor.color(from: board.color!) ?? UIColor.systemBlue
    }

    private func save() {
        CoreDataStack.shared.saveContext()
    }
}
