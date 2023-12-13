import SwiftUI

struct QuizView: View {
    @State private var quizs: [Quiz1] = [
        Quiz1(question: "Quels sont les nutriments essentiels que l'on trouve généralement dans les fruits et légumes?",
              answer1: "a) Protéines et lipides", answer2: "b) Fibres, potassium, vitamine C et folates", answer3: "c) Glucides simples et graisses saturées", correctAnswerNumber: 2),
        Quiz1(question: "Pourquoi les fruits et légumes sont-ils considérés comme bénéfiques pour la santé?",
              answer1: "a) Ils contiennent des milliers de composés chimiques artificiels.", answer2: "b) Ils sont riches en graisses saturées.", answer3: "c) Ils sont sources de fibres, de vitamine C, de potassium et de composés phytochimiques protecteurs.", correctAnswerNumber: 3),
        Quiz1(question: "Quel rôle jouent les composés phytochimiques présents dans les fruits et légumes?",
              answer1: "a) Ils sont responsables du goût sucré des fruits.", answer2: "b) Ils protègent contre les maladies.", answer3: "c) Ils n'ont aucun effet sur la santé.", correctAnswerNumber: 2),
    ]

    @State private var numberOfGoodAnswers: Int = 0
    @State private var currentQuizIndex: Int = 0
    @State private var isQuizComplete: Bool = false
    @State private var userEmail: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var remainingTime: Int = 10
    @State private var timer: Timer?

    var body: some View {
        VStack {
            if !isQuizComplete {
                Text("Time: \(remainingTime) seconds")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
            }

            if currentQuizIndex < quizs.count {
                // Progress Bar
                ProgressBar(value: CGFloat(currentQuizIndex + 1) / CGFloat(quizs.count))
                    .frame(height: 10)
                    .padding()

                Text(quizs[currentQuizIndex].question)
                    .font(.title)
                    .colorInvert()
                    .bold()
                    .padding()
                    .background(Color.yellow)

                VStack {
                    Button(action: {
                        self.handleAnswer(1)
                    }) {
                        Text(quizs[currentQuizIndex].answer1)
                            .padding()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(quizs[currentQuizIndex].selectedAnswer == 1 ? Color.gray : Color.clear)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        self.handleAnswer(2)
                    }) {
                        Text(quizs[currentQuizIndex].answer2)
                            .padding()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(quizs[currentQuizIndex].selectedAnswer == 2 ? Color.gray : Color.clear)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        self.handleAnswer(3)
                    }) {
                        Text(quizs[currentQuizIndex].answer3)
                            .padding()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(quizs[currentQuizIndex].selectedAnswer == 3 ? Color.gray : Color.clear)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }

            if isQuizComplete {
                Text("Score: \(numberOfGoodAnswers)")
                    .font(.headline)
                    .padding()

                Text(resultMessage)
                    .font(.title)
                    .foregroundColor(resultColor)
                    .padding()

                if numberOfGoodAnswers == quizs.count {
                    Text("Congratulations! You have a certificate!")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()

                    TextField("Put your e-mail here, please", text: $userEmail)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        self.sendEmailConfirmation(email: self.userEmail)
                        self.showAlert = true
                        self.alertMessage = "Check your mail, please"
                    }) {
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                            .padding()
                    }
                }

                // Restart Quiz button
                Button(action: {
                    self.resetQuiz()
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .padding()

                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage))
        }
    }

    var resultMessage: String {
        if numberOfGoodAnswers == 0 {
            return "Try again!"
        } else if numberOfGoodAnswers < quizs.count {
            return "Good!"
        } else {
            return "Congratulations!!!"
        }
    }

    var resultColor: Color {
        if numberOfGoodAnswers == 0 {
            return .red
        } else if numberOfGoodAnswers < quizs.count {
            return .yellow
        } else {
            return .green
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                handleAnswer(0)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetQuiz() {
        numberOfGoodAnswers = 0
        currentQuizIndex = 0
        isQuizComplete = false
        remainingTime = 10
        startTimer()
    }
    
    func handleAnswer(_ answerID: Int) {
        guard !isQuizComplete else {
            return
        }
        
        var quiz = quizs[currentQuizIndex]
        quiz.selectedAnswer = answerID
        
        if quiz.isCorrect(answerNumber: answerID) {
            numberOfGoodAnswers += 1
        }
        
        currentQuizIndex += 1
        if currentQuizIndex >= quizs.count {
            isQuizComplete = true
            stopTimer()
        } else {
            remainingTime = 10
        }
    }
    
    func sendEmailConfirmation(email: String) {
        guard let url = URL(string: "\(AppConfig.apiUrl)/quiz-completion") else {
            print("Invalid URL")
            return
        }

        let body: [String: Any] = [
            "email": email
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending email request: \(error)")
                return
            }

            // Handle the response from the server (success or failure)
        }.resume()
    }
    
    struct QuizView_Previews: PreviewProvider {
        static var previews: some View {
            QuizView()
        }
    }
}

struct ProgressBar: View {
    var value: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))

                Rectangle()
                    .frame(width: min(self.value * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
