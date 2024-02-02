//
//  BoardSettingsView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/29/24.
//

import SwiftUI

struct BoardSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var board: Board
    @State private var boardName: String
    @State private var selectedColor: UIColor
    
    init(board: Board) {
        self.board = board  // Assigning the board to the observed object
        _boardName = State(initialValue: board.name ?? "")
        _selectedColor = State(initialValue: UIColor.color(from: board.color!) ?? UIColor.systemBlue)
    }
    
    var body: some View {
        Form {
            TextField("Board Name", text: $boardName)
            
            ColorPicker("Board Color", selection: Binding(get: {
                Color(selectedColor)
            }, set: { newValue in
                selectedColor = UIColor(newValue)
            }))
            
            Button("Save") {
                saveBoardSettings()
            }
        }
        .navigationTitle("Board Settings")
    }
    
    private func saveBoardSettings() {
        board.name = boardName
        board.color = selectedColor.toData()
        CoreDataStack.shared.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}
