//
//  AuthNetworkRequest.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.11.2022.
//

import Foundation

protocol AuthNetworkRequest: NetworkRequest {
}

extension AuthNetworkRequest {
    var host: String { APIConstants.authURL }
    var hostPath: String { APIConstants.authURLPath }
}
