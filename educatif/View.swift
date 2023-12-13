//
//  View.swift
//  educatif
//
//  Created by sarrabs on 29/11/2023.
//

import SwiftUI

extension View {
    // Fonction pour afficher une image à partir d'une URL
    func remoteImage(url: String, placeholder: String = "photo") -> some View {
        if let _ = URL(string: url),
           let uiImage = UIImage(systemName: placeholder) {
            return Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
        } else {
            return Image(systemName: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
        }
    }
}
