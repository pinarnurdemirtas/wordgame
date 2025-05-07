import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class ViewController: UIViewController {

    var score = 0
    var currentQuestionIndex = 0
    var timer: Timer?
    var timeLeft = 20

    let allQuestions = [
        (englishWord: "Apple", options: ["Elma", "Armut", "Kiraz", "Portakal"], correctAnswer: "Elma"),
        (englishWord: "House", options: ["Ev", "Araba", "Gemi", "Uçak"], correctAnswer: "Ev"),
        (englishWord: "Book", options: ["Kitap", "Dergi", "Gazete", "Defter"], correctAnswer: "Kitap"),
        (englishWord: "Dog", options: ["Köpek", "Kedi", "Kuş", "Balık"], correctAnswer: "Köpek"),
        (englishWord: "Water", options: ["Su", "Çay", "Süt", "Meyve Suyu"], correctAnswer: "Su"),
        (englishWord: "Sun", options: ["Güneş", "Ay", "Yıldız", "Bulut"], correctAnswer: "Güneş"),
        (englishWord: "Chair", options: ["Sandalye", "Masa", "Yatak", "Dolap"], correctAnswer: "Sandalye"),
        (englishWord: "Car", options: ["Araba", "Otobüs", "Tren", "Uçak"], correctAnswer: "Araba"),
        (englishWord: "Pen", options: ["Kalem", "Silgi", "Defter", "Kitap"], correctAnswer: "Kalem"),
        (englishWord: "Milk", options: ["Süt", "Su", "Kola", "Meyve suyu"], correctAnswer: "Süt"),
        (englishWord: "Phone", options: ["Telefon", "Televizyon", "Radyo", "Kamera"], correctAnswer: "Telefon"),
        (englishWord: "Table", options: ["Masa", "Sandalye", "Raf", "Dolap"], correctAnswer: "Masa"),
        (englishWord: "Window", options: ["Pencere", "Kapı", "Duvar", "Tavan"], correctAnswer: "Pencere"),
        (englishWord: "Computer", options: ["Bilgisayar", "Tablet", "Telefon", "Televizyon"], correctAnswer: "Bilgisayar"),
        (englishWord: "Tree", options: ["Ağaç", "Çiçek", "Çimen", "Toprak"], correctAnswer: "Ağaç")
    ]

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myView2: UIView!
    @IBOutlet weak var myView3: UIView!
    @IBOutlet weak var myView4: UIView!
    @IBOutlet weak var myView5: UIView!
    
    var questions: [(englishWord: String, options: [String], correctAnswer: String)] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = allQuestions.shuffled().prefix(10).map { $0 }

        setupUI()
        updateUI()
        startTimer()
        
        setupUI()
        updateUI()
        startTimer()
    }

    func setupUI() {
        myView.layer.cornerRadius = 50
        myView.layer.masksToBounds = true
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 4

        myView2.layer.cornerRadius = 20
        myView2.layer.masksToBounds = true
        myView2.layer.shadowColor = UIColor.gray.cgColor
        myView2.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView2.layer.shadowOpacity = 0.5
        myView2.layer.shadowRadius = 4

        myView4.layer.cornerRadius = 8
        myView4.layer.masksToBounds = true
        myView5.layer.cornerRadius = 8
        myView5.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.frame = myView.bounds
        myView.layer.insertSublayer(gradientLayer, at: 0)

        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer2.frame = myView4.bounds
        myView4.layer.insertSublayer(gradientLayer2, at: 0)

        let gradientLayer4 = CAGradientLayer()
        gradientLayer4.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer4.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer4.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer4.frame = myView5.bounds
        myView5.layer.insertSublayer(gradientLayer4, at: 0)

        let gradientLayer3 = CAGradientLayer()
        gradientLayer3.colors = [
            UIColor(hex: "#436758").cgColor,
            UIColor(hex: "#4d7665").cgColor,
            UIColor(hex: "#7eab98").cgColor
        ]
        gradientLayer3.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer3.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer3.frame = myView3.bounds
        myView3.layer.insertSublayer(gradientLayer3, at: 0)
    }

    func startTimer() {
        timeLeft = 10
        timerLabel.text = "\(timeLeft)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft)"
        if timeLeft == 0 {
            nextQuestion()
        }
    }

    
    func updateUI() {
        let currentQuestion = questions[currentQuestionIndex]
        scoreLabel.text = "\(score)"
        questionLabel.text = "Translate the word: \(currentQuestion.englishWord)"
        for (index, button) in optionButtons.enumerated() {
            button.setTitle(currentQuestion.options[index], for: .normal)
        }
    }

    @IBAction func optionSelected(_ sender: UIButton) {
        let selectedAnswer = sender.titleLabel?.text
        let correctAnswer = questions[currentQuestionIndex].correctAnswer

        if selectedAnswer == correctAnswer {
            score += 10
        }

        nextQuestion()
    }

    func nextQuestion() {
        timer?.invalidate()
        currentQuestionIndex += 1

        if currentQuestionIndex >= questions.count {
            showGameOverAlert()
        } else {
            updateUI()
            startTimer()
        }
    }

    func showGameOverAlert() {
        let alert = UIAlertController(
            title: "Oyun Bitti",
            message: "Toplam Skorunuz: \(score)",
            preferredStyle: .alert
        )

        let restartAction = UIAlertAction(title: "Tekrar Başla", style: .default) { _ in
            self.score = 0
            self.currentQuestionIndex = 0
            self.updateUI()
            self.startTimer()
        }

        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
}
