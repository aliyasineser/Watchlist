//
//  AuthWebView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 08.11.22.
//

import SwiftUI

struct AuthWebView: View {

    @State var token: String?
    @State var isAuthFinished: Bool = false

    var body: some View {
        ScrollView {
            if let token, let url = AuthService.shared.buildPermissionUrl(requestToken: token) {
                AuthPermissionRootView(viewModel: AuthPermissionViewModel(url: url))
            }
        }
        .onAppear {
            Task {
                self.token = await AuthService.shared.fetchRequestToken()
            }
        }
    }
}

struct AuthWebView_Previews: PreviewProvider {
    static var previews: some View {
        AuthWebView()
    }
}
