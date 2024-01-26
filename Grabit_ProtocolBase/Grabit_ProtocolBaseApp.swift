//
//  Grabit_ProtocolBaseApp.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

@main
struct Grabit_ProtocolBaseApp: App {
    var body: some Scene {
        WindowGroup {
            BoardView()
                .frame(minWidth: 350, minHeight: 250)
        }
        .defaultSize(CGSize(width: 350, height: 350))
        .windowResizability(.contentMinSize)
    }
}
