//
//  createViewModel.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func createViewModel(for url: URL) -> URLPreviewViewModel {
        if let existingViewModel = viewModelCache[url] {
            return existingViewModel
        } else {
            let newViewModel = URLPreviewViewModel(url: url)
            viewModelCache[url] = newViewModel
            return newViewModel
        }
    }
}
