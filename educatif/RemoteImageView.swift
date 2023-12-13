//
//  RemoteImageView.swift
//  educatif
//
//  Created by sarrabs on 5/12/2023.
//

import SwiftUI

struct RemoteImageView: View {
    @StateObject private var imageLoader: ImageLoader

    init(url: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        if let uiImage = UIImage(data: imageLoader.data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Text("Loading...")
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var data = Data()

    init(url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.data = data
                }
            }
        }.resume()
    }
}
