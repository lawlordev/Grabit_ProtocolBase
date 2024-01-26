//
//  createViewModel.swift
//  Grabit_ProtocolBase
//
//  Created by Joseph Lawlor on 1/25/24.
//

import Foundation

extension BoardView {
    func createViewModel(for url: URL) -> URLPreviewViewModel {
        return viewModelCache[url]!
    }
}
