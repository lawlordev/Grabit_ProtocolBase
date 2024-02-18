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
        self.board = board
        _boardName = State(initialValue: board.name ?? "")
        
        if let colorData = board.color {
            _selectedColor = State(initialValue: UIColor.color(from: colorData) ?? UIColor.systemBlue)
        } else {
            _selectedColor = State(initialValue: UIColor.systemBlue)
        }
    }
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Board Name", text: $boardName)
            }
            
            Section("Color") {
                ColorPicker("Board Color", selection: Binding(get: {
                    Color(selectedColor)
                }, set: { newValue in
                    selectedColor = UIColor(newValue)
                }))
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back", systemImage: "chevron.left") {
                    saveBoardSettings()
                }
            }
        }
    }
    
    private func saveBoardSettings() {
        board.name = boardName
        board.color = selectedColor.toData()
        CoreDataStack.shared.saveContext()
        NotificationCenter.default.post(name: .boardNameDidChange, object: nil)
        presentationMode.wrappedValue.dismiss()
    }
}

extension Notification.Name {
    static let boardNameDidChange = Notification.Name("boardNameDidChange")
}
