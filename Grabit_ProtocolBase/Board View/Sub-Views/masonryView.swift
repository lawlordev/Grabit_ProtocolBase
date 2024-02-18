//
//  masonryView.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import SwiftUI
import SwiftUIMasonry

extension BoardView {
    func masonryView(for geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let numberOfColumns = max(2, Int(width / (minimumItemDimensions + 10)))
        let filteredItems = searchText == "" ? droppedItems : searchItems(query: searchText)
        
        return VMasonry(columns: numberOfColumns) {
            ForEach(filteredItems, id: \.id) { item in
                if let index = filteredItems.firstIndex(where: { $0.id == item.id }) {
                    masonryItem(for: item, at: index)
                }
            }
        }
        .padding()
        .animation(.easeInOut, value: droppedItems.map { $0.id })
        .animation(.easeInOut, value: numberOfColumns)
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            itemActionsView
        })
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search")
    }
}

extension BoardView {
    func searchItems(query: String) -> [DroppableItem] {
        droppedItems.filter { item in
            switch item {
            case let textItem as TextItem:
                return textItem.text.lowercased().contains(query.lowercased())
            case let imageItem as ImageItem:
                // Handle optional UIImage
                if let image = imageItem.image {
                    // Implement image classification and keyword generation here
                    let keywords = classifyImage(image)
                    return keywords.contains(query)
                }
                return false // or an alternative strategy for items without an image
            case let urlItem as URLItem:
                // Assuming you have a method to extract the title of the URL
                let title = getTitleFromURL(urlItem.url)
                return title.lowercased().contains(query.lowercased())
            case let pdfItem as PDFItem:
                return pdfItem.title.lowercased().contains(query.lowercased())
            default:
                return false
            }
        }
    }
    
    private func classifyImage(_ image: UIImage) -> [String] {
        // Implement Vision and Core ML image classification here
        // Refer to https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml
        // Return a list of keywords describing the image
        return ["Image"]
    }
    
    private func getTitleFromURL(_ url: URL) -> String {
        // Implement a method to extract the title from a webpage URL
        // This could involve downloading the webpage and parsing the title tag
        return "Website"
    }
}
