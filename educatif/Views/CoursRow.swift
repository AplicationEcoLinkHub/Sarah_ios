//
//  CoursRow.swift
//  educatif
//
//  Created by sarrabs on 29/11/2023.
//

// CoursRow.swift
import SwiftUI

struct CoursRow: View {
    let cours: Cours
    @ObservedObject var viewModel: CoursViewModel

    @State private var tapCount: Int = 0

    var body: some View {
        HStack {
            RemoteImageView(url: cours.titleImage)
                .frame(width: 80, height: 80)
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(cours.title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#00574B"))
            }

            Spacer()

            Button(action: {
                tapCount += 1
                viewModel.toggleFavorite(for: cours)
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(tapCount % 2 == 1 ? Color.red : Color.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 5)
    }

    struct CoursRow_Previews: PreviewProvider {
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

            return CoursRow(cours: sampleCours, viewModel: viewModel)
                .previewLayout(.fixed(width: 300, height: 100))
                .padding()
        }
    }
}
