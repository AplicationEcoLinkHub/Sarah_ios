//
//  AddCoursView.swift
//  educatif
//
//  Created by sarrabs on 29/11/2023.
//

// AddCoursView.swift
import SwiftUI

struct AddCoursView: View {
    @ObservedObject var viewModel: CoursViewModel
    @State private var imageURL = ""
    @State private var title = ""
    @State private var header = ""

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let _ = geometry.size.height

                        let radius = width * 0.5

                        path.addArc(center: CGPoint(x: width * 0.5, y: radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
                    }
                    .fill(Color(hex: "8BC34A"))
                    .edgesIgnoringSafeArea(.top)
                    .rotationEffect(.degrees(180))
                }
                .frame(height: 100)

                TextField("Image URL", text: $imageURL)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Title", text: $title)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Header", text: $header)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Button(action: {
                    guard !imageURL.isEmpty, !title.isEmpty, !header.isEmpty else {
                        // Show an alert or message to fill in all fields.
                        return
                    }

                    let newCours = Cours(id: UUID().uuidString, titleImage: imageURL, title: title, header: header, favori: false)

                    viewModel.addCours(newCours: newCours)
                }) {
                    Text("Add Cours")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "#00574B"))
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Add Cours")
        }
    }
    struct AddCoursView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = CoursViewModel()

            return AddCoursView(viewModel: viewModel)
                .previewDevice("iPhone 14 Pro")
        }
    }
}
