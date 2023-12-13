//
//  Quiz1.swift
//  educatif
//
//  Created by sarrabs on 5/12/2023.
//

import SwiftUI

struct Quiz1 {
    var question: String
    var answer1: String
    var answer2: String
    var answer3: String
    var correctAnswerNumber: Int
    var selectedAnswer: Int = 0  // Added to store the user's selected answer

    func isCorrect(answerNumber: Int) -> Bool {
        return answerNumber == correctAnswerNumber
    }
}

enum QuizResult: Decodable {  // Add Decodable conformance
    case completed(score: Int)

    private enum CodingKeys: String, CodingKey {
        case score
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let score = try container.decode(Int.self, forKey: .score)
        self = .completed(score: score)
    }
}
