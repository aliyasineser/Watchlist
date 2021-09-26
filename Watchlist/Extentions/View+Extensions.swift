//
//  View+Extentions.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 21.06.2021.
//

import Foundation
import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        modifier(HideNavigationBarModifier())
    }
}
