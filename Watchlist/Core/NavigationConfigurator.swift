//
//  NavigationConfigurator.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 15.08.2021.
//

import UIKit
import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let navController = uiViewController.navigationController {
            self.configure(navController)
        }
    }
}
