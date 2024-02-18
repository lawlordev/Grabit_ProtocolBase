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
        VStack(alignment: .leading) {
            Image(uiImage: thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
    }
}
