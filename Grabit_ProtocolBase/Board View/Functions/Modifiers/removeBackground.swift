//
//  removeBackground.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation
import BackgroundRemoval

extension BoardView {
    func removeBackgroundFromImage(at index: Int) {
        guard index < droppedItems.count,
              let imageItem = droppedItems[index] as? ImageItem else {
            print("The item at index \(index) is not an image.")
            return
        }
        
        let backgroundRemoval = BackgroundRemoval()
        lastAction = LastAction(actionType: .edit, originalItem: imageItem, index: index)
        
        do {
            let imageWithBackgroundRemoved = try backgroundRemoval.removeBackground(image: imageItem.image)
            droppedItems[index] = ImageItem(image: imageWithBackgroundRemoved)
            
            showUndoButton = true
        } catch {
            print("Background removal error: \(error)")
            // Handle the error accordingly
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if showUndoButton {
                showUndoButton = false
                lastAction = nil
            }
        }
    }
}
