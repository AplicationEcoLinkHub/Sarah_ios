//
//  CoursViewModel.swift
//  educatif
//
//  Created by sarrabs on 27/11/2023.
//

// CoursViewModel.swift
import SwiftUI

class CoursViewModel: ObservableObject {
    @Published var cours: [Cours] = []
    @Published var showFavoritesOnly: Bool = false
    @Published var searchText: String = ""
    @Published var isCoursFound = true
    @Published var errorMessage: String?
    
    // Function to toggle the favorites filter
    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
        // Reload courses when the favorites filter is toggled
        loadCours()
    }

    // Function to load courses from the server
    func loadCours() {
        var url: URL
        print("sarra")
        if showFavoritesOnly {
            // Load only favorite courses
            url = URL(string: "\(AppConfig.apiUrl)/api/cours/favorites")!
        } else {
            // Load all courses
            url = URL(string: "\(AppConfig.apiUrl)/api/cours")!
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            print(httpResponse.statusCode)
                do {
                    let decodedData = try JSONDecoder().decode([Cours].self, from: data!)
                    DispatchQueue.main.async {
                        self.cours = decodedData
                    }
                } catch {
                    print("Error decoding cours: \(error)")
                }
            
        }.resume()
    }

    // Function to toggle the favorite status of a course
    func toggleFavorite(for cours: Cours) {
        guard var updatedCours = self.cours.first(where: { $0.id == cours.id }) else {
            print("Course not found")
            return
        }

        updatedCours.favori.toggle()

        guard let url = URL(string: "\(AppConfig.apiUrl)/api/cours/\(cours.id)/favori") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        do {
            let jsonData = try JSONEncoder().encode(updatedCours)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updatedCours: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error toggling favorite: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Function to update a course on the server
    func updateCours(updatedCours: Cours) {
        guard let index = cours.firstIndex(where: { $0.id == updatedCours.id }) else {
            print("Course not found")
            return
        }

        guard let url = URL(string: "\(AppConfig.apiUrl)/api/cours/\(updatedCours.id)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(updatedCours)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updatedCours: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating cours: \(error.localizedDescription)")
            } else {
                // Assuming the server responds with success
                DispatchQueue.main.async {
                    self.cours[index] = updatedCours
                }
            }
        }.resume()
    }

    // Function to delete a course from the server
    func deleteCours(cours: Cours) {
        guard let url = URL(string: "\(AppConfig.apiUrl)/api/cours/\(cours.id)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error deleting cours: \(error.localizedDescription)")
            } else {
                // Assuming the server responds with success
                DispatchQueue.main.async {
                    if let index = self.cours.firstIndex(where: { $0.id == cours.id }) {
                        self.cours.remove(at: index)
                    }
                }
            }
        }.resume()
    }

    // Function to add a new course to the server
    func addCours(newCours: Cours) {
        guard let url = URL(string: "\(AppConfig.apiUrl)/api/cours") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(newCours)
            request.httpBody = jsonData
        } catch {
            print("Error encoding newCours: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error adding cours: \(error.localizedDescription)")
            } else {
                // Assuming the server responds with success
                DispatchQueue.main.async {
                    self.loadCours()
                }
            }
        }.resume()
    }
    func performSearch() {
        let filteredCours = self.filteredCours()
        isCoursFound = !filteredCours.isEmpty
        if !isCoursFound {
            errorMessage = "Aucun cours trouvé."
        }
    }

    func filteredCours() -> [Cours] {
        if searchText.isEmpty {
            return showFavoritesOnly ? cours.filter { $0.favori } : cours
        } else {
            return cours.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}
