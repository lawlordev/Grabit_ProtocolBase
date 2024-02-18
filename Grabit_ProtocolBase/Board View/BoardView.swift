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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var board: Board
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedBoardManager : SelectedBoardManager
    @Environment(\.openWindow) private var openWindow
    
    @State private var key = UUID()
    
    @State var droppedItems: [any DroppableItem] = []
    @State var viewModelCache: [URL: URLPreviewViewModel] = [:]
    @State var selectedItemId: UUID? = nil
    @State var showingOrnament: Bool = false
    @State var showUndoButton: Bool = false
    @State var selectionInProgress: Bool = false
    @State var selectedItems: [UUID] = []
    @State var draggingItemID: UUID?
    @State var searchText: String = ""
    @State var isSearching: Bool = false
    @State var showPDFPreview: Bool = false
    @State var justCopied: Bool = false
    
    let minimumItemDimensions: CGFloat = 160
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.overlay(Text(key.uuidString).hidden())
                
                if let colorData = board.color,
                   let uiColor = CoreDataStack.shared.fetchColor(from: colorData) {
                    Color(uiColor).opacity(0.2)
                        .ignoresSafeArea()
                }
                
                GeometryReader { geometry in
                    ScrollView {
                        masonryView(for: geometry)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onDrop(of: [UTType.text.identifier, UTType.rtfd.identifier, UTType.url.identifier, UTType.image.identifier, UTType.pdf.identifier, UTType.movie.identifier], isTargeted: nil) { providers in
                        // Reset draggingItemID to nil, as the drag operation has ended
                        defer { draggingItemID = nil }
                        
                        // Proceed with handling the drop
                        return handleDropInto(providers: providers)
                    }
                    .onTapGesture(count: 2) {
                        handlePaste()
                    }
                    .onTapGesture(count: 1) {
                        withAnimation(.interactiveSpring) {
                            selectedItemId = nil
                            showingOrnament = false
                        }
                    }
                }
                
                if justCopied {
                    VStack {
                        Spacer() // Pushes the text to the bottom
                        HStack {
                            Spacer() // Centers the text horizontally
                            Text("Copied!")
                                .font(.headline)
                                .padding()
                                .glassBackgroundEffect()
                                .cornerRadius(16)
                            Spacer()
                        }
                        Spacer().frame(height: 32) // Adjust this for desired distance from the bottom
                    }
                    .transition(.opacity) // Optional: for fade in/out effect
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            justCopied = false
                        }
                    }
                }
            }
            .navigationTitle(board.name ?? "Unititled")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: BoardSettingsView(board: board).environmentObject(board)) {
                        Label("Edit", systemImage: "pencil")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if !selectedBoardManager.isHomeViewOpen {
                        withAnimation(.interactiveSpring) {
                            Button("Home", systemImage: "house") {
                                openHomeWindow()
                            }
                        }
                    }
                }
            }
            .ornament(attachmentAnchor: .scene(.bottom), ornament: {
                HStack {
                    if !droppedItems.isEmpty && selectedItemId == nil {
                        Button(selectionInProgress ? "Done" : "Select") {
                            withAnimation(.interactiveSpring) {
                                selectedItemId = nil
                                selectedItems = []
                                selectionInProgress.toggle()
                            }
                        }
                        .glassBackgroundEffect()
                    }
                    
                    if selectionInProgress {
                        Button(selectedItems.count == droppedItems.count ? "Deselect all" : "Select all") {
                            withAnimation(.interactiveSpring) {
                                if selectedItems.count == droppedItems.count {
                                    selectedItems.removeAll()
                                } else {
                                    selectedItems = Array(droppedItems.map { $0.id })
                                }
                            }
                        }
                        .glassBackgroundEffect()
                    }
                    
                    if selectionInProgress && !selectedItems.isEmpty {
                        Button("Delete") {
                            withAnimation(.interactiveSpring) {
                                for id in selectedItems {
                                    removeItem(with: id)
                                }
                                
                                selectedItems.removeAll()
                                
                                if droppedItems.isEmpty {
                                    selectionInProgress = false
                                }
                            }
                        }
                        .foregroundStyle(Color.red)
                        .glassBackgroundEffect()
                    }
                }
            })
            .onAppear {
                refreshBoard()
            }
        }
    }
    
    private func openHomeWindow() {
        openWindow(id: "main-window")
    }
    
    func refreshBoard() {
        self.key = UUID()
        self.viewContext.refresh(self.board, mergeChanges: true)
        
        let items = CoreDataStack.shared.fetchItems(for: board).sorted {
            let timestamp0 = $0.timestamp ?? .distantPast // Use a default value if nil
            let timestamp1 = $1.timestamp ?? .distantPast
            
            if $0.favorite == $1.favorite {
                return timestamp0 > timestamp1 // Sort by timestamp if favorite status is the same
            }
            return $0.favorite && !$1.favorite // Sort favorites first
        }
        
        self.droppedItems = items.compactMap { item in
            guard let data = item.data, let type = item.type else { return nil }
            if var droppableItem = CoreDataStack.shared.decodeDroppableItem(from: data, type: type) {
                // Set the favorite status based on the Core Data value
                droppableItem.favorite = item.favorite
                
                // Populate the viewModelCache for URL items
                if let urlItem = droppableItem as? URLItem {
                    viewModelCache[urlItem.url] = URLPreviewViewModel(url: urlItem.url)
                }
                
                return droppableItem
            }
            return nil
        }
    }
}
