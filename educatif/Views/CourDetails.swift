//
//  CourDetails.swift
//  educatif
//
//  Created by sarrabs on 27/11/2023.
//

// CourDetails.swift

import SwiftUI

struct CourDetails: View {
    let cours: Cours
    @ObservedObject var viewModel: CoursViewModel
    @State private var updatedCours: Cours
    @State private var isShowingQuiz = false

    init(cours: Cours, viewModel: CoursViewModel) {
        self.cours = cours
        self.viewModel = viewModel
        self._updatedCours = State(initialValue: cours)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    GeometryReader { geometry in
                        Path { path in
                            let width = geometry.size.width
                            let radius = width * 0.5

                            path.addArc(center: CGPoint(x: width * 0.5, y: radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
                        }
                        .fill(Color(hex: "8BC34A"))
                        .rotationEffect(.degrees(180))
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)
                    }

                    Spacer()

                    VStack(alignment: .center, spacing: 20) {
                        RemoteImageView(url: updatedCours.titleImage)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .padding()

                        Text(updatedCours.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#00574B"))
                            .padding()

                        Text(updatedCours.header)
                            .foregroundColor(Color(hex: "#00574B"))
                            .padding(.bottom)

                        Spacer()

                        Button(action: {
                            isShowingQuiz.toggle()
                        }) {
                            HStack {
                                Image(systemName: "book")
                                    .font(.title)
                                Text("Démarrer le Quiz")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "#00574B"))
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $isShowingQuiz) {
                            QuizView()
                        }

                        Button(action: {
                            viewModel.toggleFavorite(for: updatedCours)
                        }) {
                            Image(systemName: updatedCours.favori ? "heart.fill" : "heart")
                                .foregroundColor(updatedCours.favori ? Color.red : .gray)
                        }
                        .padding()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CourDetails_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCours = Cours(
            id: "sampleId",
            titleImage: "sampleImageUrl",
            title: "Sample Title",
            header: "Sample Header",
            favori: false
        )

        let viewModel = CoursViewModel()
        viewModel.cours = [sampleCours]

        return NavigationView {
            CourDetails(cours: sampleCours, viewModel: viewModel)
        }
        .previewDevice("iPhone 14 Pro")
    }
}
