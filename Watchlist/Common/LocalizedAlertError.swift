//
//  LocalizedAlertError.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 15.11.22.
//

import Foundation

struct LocalizedAlertError: LocalizedError {
    let underlyingError: Error
    var errorDescription: String? {
        underlyingError.localizedDescription
    }
    var recoverySuggestion: String? {
        (underlyingError as? LocalizedError)?.recoverySuggestion
    }

    init?(error: Error?) {
        guard let error else { return nil }
        underlyingError = error
    }
}
