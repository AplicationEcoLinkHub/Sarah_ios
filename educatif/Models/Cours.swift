//
//  Cours.swift
//  educatif
//
//  Created by sarrabs on 27/11/2023.
//

// Cours.swift
import Foundation

struct Cours: Identifiable, Codable {
    let id: String
    let titleImage: String
    let title: String
    let header: String
    var favori: Bool 

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case titleImage
        case title
        case header
        case favori
    }
}
