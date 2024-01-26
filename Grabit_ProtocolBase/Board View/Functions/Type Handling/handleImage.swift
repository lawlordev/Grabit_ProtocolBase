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
    }
}
