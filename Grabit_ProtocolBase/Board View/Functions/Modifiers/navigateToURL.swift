//
//  navigateToURL.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import SafariServices

extension BoardView {
    func navigateToURL(_ url: URL) {
        // Check if the application can open the URL
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open URL")
        }
    }
}
