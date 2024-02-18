//
//  handleImage.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func handleImage(image: UIImage) {
        let imageItem = ImageItem(image: image)
        addItem(imageItem)
        
        // Save to Core Data
        if let encodedData = CoreDataStack.shared.encodeDroppableItem(imageItem) {
            CoreDataStack.shared.addItem(to: board, id: imageItem.id, type: "ImageItem", data: encodedData)
        }
    }
}
