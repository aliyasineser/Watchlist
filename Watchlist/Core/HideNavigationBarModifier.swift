//
//  HideNavigationBarModifier.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 21.06.2021.
//

import Foundation
import SwiftUI

struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("")
    }
}
