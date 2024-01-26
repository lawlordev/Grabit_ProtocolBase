//
//  BoardView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftUIMasonry

struct BoardView: View {
    @State var droppedItems: [any DroppableItem] = []
    @State var viewModelCache: [URL: URLPreviewViewModel] = [:]
    @State var selectedItemIndex: Int? = nil
    @State var showingOrnament: Bool = false
    @State var lastAction: LastAction?
    @State var showUndoButton: Bool = false
    
    let minimumItemDimensions: CGFloat = 150
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    masonryView(for: geometry)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onDrop(of: [UTType.text.identifier, UTType.url.identifier, UTType.image.identifier, UTType.pdf.identifier], isTargeted: nil) { providers in
                    handleDropInto(providers: providers)
                }
                .onTapGesture(count: 2) {
                    handlePaste()
                }
                .onTapGesture(count: 1) {
                    selectedItemIndex = nil
                    showingOrnament = false
                }
                .navigationTitle("Grabit!")
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if showUndoButton {
                        undoButton
                    }
                }
            }
        }
    }
}
