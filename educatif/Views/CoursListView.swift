//
//  CoursListView.swift
//  educatif
//
//  Created by sarrabs on 27/11/2023.
//

// CoursListView.swift

import SwiftUI

struct CoursListView: View {
    @ObservedObject var viewModel = CoursViewModel()
    

    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.55, green: 0.76, blue: 0.29))
                    .frame(width: 517, height: 215)
                    .cornerRadius(517)
                    .ignoresSafeArea(edges: .top)

                HStack {
                    TextField("Search by course title", text: $viewModel.searchText)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    Button(action: {
                        viewModel.performSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.yellow)
                            .cornerRadius(90)
                    }
                    .padding()
                }

                List {
                    ForEach(viewModel.filteredCours()) { cours in
                        NavigationLink(destination: CourDetails(cours: cours, viewModel: viewModel)) {
                            CoursRow(cours: cours, viewModel: viewModel)
                                .background(cours.favori ? Color.red.opacity(0.3) : Color.clear)
                        }
                    }
                }
                .navigationTitle("Cours")
                .navigationBarItems(
                    leading: Button(action: {
                        viewModel.toggleFavoritesOnly()
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(hex: "#00574B"))
                    },
                    trailing: HStack {
                        Button(action: {
                            viewModel.loadCours()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color(hex: "#00574B"))
                        }
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.loadCours()
                }

                if !viewModel.isCoursFound {
                    Text(viewModel.errorMessage ?? "Aucun cours trouvé.")
                        .foregroundColor(.red)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                viewModel.errorMessage = nil
                                viewModel.isCoursFound = true
                            }
                        }
                }
            }
        }
    }
}

struct CoursListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CoursViewModel()
        let sampleCours = Cours(
            id: "sampleId",
            titleImage: "sampleImageUrl",
            title: "Sample Title",
            header: "Sample Header",
            favori: false
        )

        viewModel.cours = [sampleCours]

        return CoursListView(viewModel: viewModel)
            .previewDevice("iPhone 14 Pro")
    }
}
