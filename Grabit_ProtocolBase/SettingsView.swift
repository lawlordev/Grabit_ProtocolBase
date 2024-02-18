//
//  SettingsView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 2/12/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Customize") {
                    Text("Customization options arriving soon!")
                }
                
                Section("About") {
                    Text("Version: 1.1.2")
                }
                
                Section("Feedback") {
                    Button("Contact Us") {
                        if let url = URL(string: "mailto:joseph@lawlordev.design?subject=Grabit%20App%20Inquiry") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                Text("Made with 🩸🥵🥹 & ❤️ by Joseph Lawlor - Lawlor Dev Design")
            }
        }
    }
}

#Preview {
    SettingsView()
}
