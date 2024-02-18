//
//  materialBackground.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

extension BoardView {
    func materialBackground() -> some View {
        return RoundedRectangle(cornerRadius: 16)
            .fill(Material.thinMaterial)
    }
}
