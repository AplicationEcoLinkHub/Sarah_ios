//
//  SearchView.swift
//  educatif
//
//  Created by sarrabs on 30/11/2023.
//

import SwiftUI

struct SearchView: View {
    @Binding var isSearching: Bool
    @Binding var searchText: String
    @Binding var isCoursFound: Bool
    @ObservedObject var viewModel: CoursViewModel

    var body: some View {
        VStack {
            TextField("Nom du cours", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)

            Button(action: {
                // Logic to check if the cours exists
                if viewModel.cours.contains(where: { $0.title.lowercased() == searchText.lowercased() }) {
                    isCoursFound = true
                } else {
                    isCoursFound = false
                }
            }) {
                Text("OK")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                isSearching.toggle()
            }) {
                Text("Annuler")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color.green)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}
