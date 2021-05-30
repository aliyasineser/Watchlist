//
//  ImageLoader.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import Foundation
import Combine

class ImageLoader: ObservableObject {
    var data = Data()

    init() {
    }
    
    func loadImage(urlString: String, completion: @escaping  (Data) -> Void) -> Void {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
}
