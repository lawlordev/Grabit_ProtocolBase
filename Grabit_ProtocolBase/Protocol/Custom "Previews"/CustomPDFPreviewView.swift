//
//  CustomPDFPreviewView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI

struct PDFPreviewView: View {
    let url: URL
    let title: String
    let thumbnail: UIImage

    var body: some View {
        VStack {
            Image(uiImage: thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
            Text(title)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
