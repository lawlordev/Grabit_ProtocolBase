//
//  handlePlainText.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func handlePlainText(text: String) {
        if let url = URL(string: text), UIApplication.shared.canOpenURL(url) {
            handleURL(url)
        } else {
            let textItem = TextItem(text: text)
            addItem(textItem)
        }
    }
}
