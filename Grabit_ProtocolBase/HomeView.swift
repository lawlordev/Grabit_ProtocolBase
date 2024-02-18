//
//  HomeView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/26/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject var selectedBoardManager: SelectedBoardManager
    @State private var refreshToggle: Bool = false
    @State private var searchText: String = ""
    @State private var notificationObserver: NSObjectProtocol?

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Board.timestamp, ascending: false)  // Sort by timestamp
        ],
        animation: .default)
    private var fetchedBoards: FetchedResults<Board>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedBoards, id: \.self) { board in
                    HStack {
                        Button(action: { selectBoard(board) }) {
                            VStack(alignment: .leading) {
                                Text(board.name ?? "Unnamed Board")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(timestampText(for: board))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        NavigationLink(destination: BoardSettingsView(board: board)) {
                            Label("Settings", systemImage: "gear")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete(perform: deleteBoard)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search Boards...")
            .onChange(of: searchText) { _, newValue in
                if !newValue.isEmpty {
                    // Filter based on the search text
                    self.fetchedBoards.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", newValue)
                } else {
                    // Reset the filter when search text is empty
                    self.fetchedBoards.nsPredicate = nil
                }
            }
            .onAppear {
                notificationObserver = NotificationCenter.default.addObserver(forName: .boardNameDidChange, object: nil, queue: .main) { _ in
                    self.refreshToggle.toggle()
                }
                selectedBoardManager.isHomeViewOpen = true
            }
            .onDisappear {
                if let observer = notificationObserver {
                    NotificationCenter.default.removeObserver(observer)
                    notificationObserver = nil
                }
                selectedBoardManager.isHomeViewOpen = false
            }
            
            Text(refreshToggle.description).hidden()
                .navigationTitle("Grabit!")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                        }

                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            createNewBoard()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }

    private func createNewBoard() {
        let newBoard = Board(context: viewContext)
        newBoard.name = "Untitled"
        newBoard.color = UIColor.systemBlue.toData()
        newBoard.id = UUID()
        do {
            try viewContext.save()
            selectBoard(newBoard)
        } catch {
            print("Error saving context: \(error)")
        }
    }

    private func selectBoard(_ board: Board) {
        guard let boardID = board.id else {
            return
        }
        openWindow(id: "board-viewer", value: boardID)
        CoreDataStack.shared.updateBoardTimestamp(board)
        refreshToggle.toggle()
    }

    private func deleteBoard(at offsets: IndexSet) {
        for index in offsets {
            let board = fetchedBoards[index]
            guard let boardID = board.id else {
                return
            }
            
            dismissWindow(id: "board-viewer", value: boardID)
            CoreDataStack.shared.deleteBoard(board)
        }
    }

    private func timestampText(for board: Board) -> String {
        guard let timestamp = board.timestamp else {
            return ""
        }
        
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(timestamp) {
            formatter.dateFormat = "h:mm a"
        } else if calendar.isDateInYesterday(timestamp) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "M/d/yyyy"
        }
        return formatter.string(from: timestamp)
    }
}

