//
//  CoreDataStack.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/28/24.
//

import SwiftUI
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    // MARK: - Board Operations
    func fetchBoard(with uuid: UUID) -> Board? {
        let fetchRequest: NSFetchRequest<Board> = Board.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return results.first // Returns the first matching Board, or nil if not found
        } catch {
            print("Error fetching board: \(error)")
            return nil
        }
    }
    
    func addBoard(name: String, color: UIColor, id: UUID, isFavorite: Bool = false) {
        let board = Board(context: persistentContainer.viewContext)
        board.name = name
        board.color = color.toData()
        board.id = id
        board.timestamp = Date() // Set current date as timestamp
        board.favorite = isFavorite
        saveContext()
    }
    
    func updateBoard(_ board: Board, name: String, color: UIColor, isFavorite: Bool, timeStamp: Date) {
        board.name = name
        board.color = color.toData()
        board.favorite = isFavorite
        board.timestamp = timeStamp
        saveContext()
    }
    
    func updateBoardTimestamp(_ board: Board) {
        board.timestamp = Date()
        saveContext()
    }
    
    func deleteBoard(_ board: Board) {
        let items = fetchItems(for: board)
        let fileManager = FileManager.default

        // Delete associated files from the documents directory
        for item in items {
            if let type = item.type, type == "PDFItem" || type == "VideoItem",
               let data = item.data,
               let droppableItem = decodeDroppableItem(from: data, type: type),
               let fileURL = (droppableItem as? PDFItem)?.url ?? (droppableItem as? VideoItem)?.url {
                try? fileManager.removeItem(at: fileURL)
            }
        }

        // Delete the board and its items from Core Data
        persistentContainer.viewContext.delete(board)
        saveContext()
    }
    
    func fetchColor(from data: Data) -> UIColor? {
        return UIColor.color(from: data)
    }
    
    // MARK: - Item Operations
    func addItem(to board: Board, id: UUID, type: String, data: Data) {
        let item = Item(context: persistentContainer.viewContext)
        item.id = id
        item.type = type
        item.data = data
        item.board = board
        item.timestamp = Date()
        item.favorite = false
        saveContext()
    }
    
    func updateItem(_ item: Item, data: Data) {
        item.data = data
        saveContext()
    }
    
    func toggleFavoriteItem(byId id: UUID) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            if let item = results.first {
                item.favorite = !item.favorite // Toggle the favorite status
                saveContext()
            }
        } catch {
            print("Error toggling favorite status: \(error)")
        }
    }
    
    func deleteItem(_ item: Item) {
        let fileManager = FileManager.default

        // Delete associated file from the documents directory
        if let type = item.type, type == "PDFItem" || type == "VideoItem",
           let data = item.data,
           let droppableItem = decodeDroppableItem(from: data, type: type),
           let fileURL = (droppableItem as? PDFItem)?.url ?? (droppableItem as? VideoItem)?.url {
            try? fileManager.removeItem(at: fileURL)
        }

        // Delete the item from Core Data
        persistentContainer.viewContext.delete(item)
        saveContext()
    }
    
    func deleteItem(byId itemId: UUID) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", itemId as CVarArg)

        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            if let item = results.first {
                // Delete associated file from the documents directory
                if let type = item.type, type == "PDFItem" || type == "VideoItem",
                   let data = item.data,
                   let droppableItem = decodeDroppableItem(from: data, type: type),
                   let fileURL = (droppableItem as? PDFItem)?.url ?? (droppableItem as? VideoItem)?.url {
                    try? FileManager.default.removeItem(at: fileURL)
                }

                // Delete the item from Core Data
                persistentContainer.viewContext.delete(item)
                saveContext()
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
    func fetchItems(for board: Board) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "board == %@", board)
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    // MARK: - Helpers
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            DispatchQueue.main.async {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

extension UIColor {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func color(from data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

extension CoreDataStack {
    func encodeDroppableItem(_ item: DroppableItem) -> Data? {
        switch item {
        case let textItem as TextItem:
            return try? JSONEncoder().encode(textItem)
        case let urlItem as URLItem:
            return try? JSONEncoder().encode(urlItem)
        case let imageItem as ImageItem:
            return try? JSONEncoder().encode(imageItem)
        case let pdfItem as PDFItem:
            return try? JSONEncoder().encode(pdfItem)
        case let videoItem as VideoItem:
            return try? JSONEncoder().encode(videoItem)
        default:
            return nil
        }
    }
    
    func decodeDroppableItem(from data: Data, type: String) -> DroppableItem? {
        switch type {
        case "TextItem":
            return try? JSONDecoder().decode(TextItem.self, from: data)
        case "URLItem":
            return try? JSONDecoder().decode(URLItem.self, from: data)
        case "ImageItem":
            return try? JSONDecoder().decode(ImageItem.self, from: data)
        case "PDFItem":
            return try? JSONDecoder().decode(PDFItem.self, from: data)
        case "VideoItem":
            return try? JSONDecoder().decode(VideoItem.self, from: data)
        default:
            return nil
        }
    }
}
