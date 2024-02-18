//
//  Grabit_ProtocolBaseApp.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import CoreData

// Shared ObservableObject
class SelectedBoardManager: ObservableObject {
    @Published var selectedBoards: [Board]?
    @Published var isHomeViewOpen: Bool = true
}

@main
struct YourApp: App {
    @StateObject var selectedBoardManager = SelectedBoardManager()
    @Environment(\.openWindow) private var openWindow
    let persistenceController = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup(id: "main-window") {
            HomeView()
                .environmentObject(selectedBoardManager)
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
                .frame(minWidth: 370, minHeight: 350)
        }
        .defaultSize(CGSize(width: 370, height: 450))
        .windowResizability(.contentMinSize)
        
        WindowGroup(id: "board-viewer", for: UUID.self) { $boardID in
            let context = persistenceController.persistentContainer.viewContext
            let request: NSFetchRequest<Board> = Board.fetchRequest()
            if let boards = try? context.fetch(request), let board = boards.first(where: { $0.id == boardID }) {
                BoardView(board: board)
                    .environment(\.managedObjectContext, context)
                    .environmentObject(selectedBoardManager)
                    .frame(minWidth: 370, minHeight: 350)
            }
        }
        .defaultSize(CGSize(width: 370, height: 450))
        .windowResizability(.contentMinSize)
    }
}
