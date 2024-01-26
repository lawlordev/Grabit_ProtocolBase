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
    @State var selectionInProgress: Bool = false
    @State var selectedItems: Set<Int> = []
    @State var draggingItemID: UUID?
    
    let minimumItemDimensions: CGFloat = 150
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    masonryView(for: geometry)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onDrop(of: [UTType.text.identifier, UTType.url.identifier, UTType.image.identifier, UTType.pdf.identifier], isTargeted: nil) { providers in
                    // Reset draggingItemID to nil, as the drag operation has ended
                    defer { draggingItemID = nil }
                    
                    // Proceed with handling the drop
                    return handleDropInto(providers: providers)
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !droppedItems.isEmpty {
                        Button(selectionInProgress ? "Done" : "Select") {
                            selectedItemIndex = nil
                            selectionInProgress.toggle()
                        }
                    }
                }
            }
            .ornament(attachmentAnchor: .scene(.bottom)) {
                HStack {
                    if selectionInProgress {
                        Button(selectedItems.count == droppedItems.count ? "Deselect all" : "Select all") {
                            if selectedItems.count == droppedItems.count {
                                selectedItems.removeAll()
                            } else {
                                selectedItems = Set(droppedItems.indices)
                            }
                        }
                    }
                    
                    if selectionInProgress && !selectedItems.isEmpty {
                        Button("Delete") {
                            for index in selectedItems.sorted(by: >) {
                                removeItem(with: droppedItems[index].id)
                            }
                            selectedItems.removeAll()
                            
                            if droppedItems.isEmpty {
                                selectionInProgress = false
                            }
                        }
                    }
                }
                .glassBackgroundEffect()
            }
        }
    }
}
