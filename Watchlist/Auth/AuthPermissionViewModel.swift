//
//  AuthPermissionViewModel.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 08.11.22.
//

import Foundation
import Combine

public protocol AuthPermissionViewModelDelegate: AnyObject {
  func authPermissionViewModel(didSignedIn signedIn: Bool)
}

protocol AuthPermissionViewModelProtocol {
  func signIn()
  var authPermissionURL: URL { get }
  var delegate: AuthPermissionViewModelDelegate? { get set }
}

final class AuthPermissionViewModel: AuthPermissionViewModelProtocol {
  weak var delegate: AuthPermissionViewModelDelegate?
  private let didSignIn = PassthroughSubject<Bool, Never>()
  let authPermissionURL: URL
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(url: URL) {
    authPermissionURL = url
    subscribe()
  }

  func signIn() {
    didSignIn.send(true)
  }

  private func subscribe() {
    didSignIn
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] signedIn in
        self?.delegate?.authPermissionViewModel(didSignedIn: signedIn)
      })
      .store(in: &disposeBag)
  }
}
