import UIKit

class ViewController: UIViewController {
    
    var counter = 0
    var guessesLeft: UILabel!
    var score: UILabel!
    var answerField: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var correctAnswer = "ac"
    var hiddenAnswer = ""
    var scoreCount = 0 {
        didSet {
            score.text = "Score: \(scoreCount)"
        }
    }
    var guessCount = 7 {
        didSet {
            guessesLeft.text = "Guesses left: \(guessCount)"
        }
    }

    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    var usedLetters :[String] = []

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        score = UILabel()
        score.translatesAutoresizingMaskIntoConstraints = false
        score.textAlignment = .left
        score.text = "Score: \(scoreCount)"
        view.addSubview(score)
        
        guessesLeft = UILabel()
        guessesLeft.translatesAutoresizingMaskIntoConstraints = false
        guessesLeft.textAlignment = .right
        guessesLeft.text = "Guesses left: \(guessCount)"
        view.addSubview(guessesLeft)
        
        answerField = UITextField()
        answerField.translatesAutoresizingMaskIntoConstraints = false
        answerField.font = UIFont.systemFont(ofSize: 24)
        answerField.text = hiddenAnswer
        answerField.textAlignment = .center
        answerField.isUserInteractionEnabled = false
        view.addSubview(answerField)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            score.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            score.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            guessesLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            guessesLeft.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            answerField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            answerField.topAnchor.constraint(equalTo: guessesLeft.bottomAnchor, constant: 20),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 120),
            buttonsView.heightAnchor.constraint(equalToConstant: 650),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: answerField.bottomAnchor, constant: 20)
        ])
        
        let width = 60
        let height = 50
        
        for row in 0..<13 {
            for column in 0..<2 {
                let letterButton = UIButton(type: .system)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle(letters[counter], for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                        
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                        
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                counter += 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.loadLevel()
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(buttonTitle)
        
        if correctAnswer.contains(buttonTitle) {
            updateHiddenAnswer()
        } else {
            guessCount -= 1
        }

        activatedButtons.append(sender)
        sender.isHidden = true

        if guessCount == 0 {
            showAlert(title: "You lose!", message: "Wanna try again?")
            if scoreCount > 0{
                scoreCount -= 1 }
        } else if hiddenAnswer == correctAnswer {
            showAlert(title: "Well done!", message: "Are you ready for next level?")
            scoreCount += 1
        }
    }
    
    func loadLevel() {
        if let levelFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                let lines = levelContents.components(separatedBy: "\n")
                correctAnswer = lines.randomElement()!
            }
        }
        
        hiddenAnswer = String(repeating: "?", count: correctAnswer.count)
        
        DispatchQueue.main.async {
            self.guessCount = 7
            self.usedLetters.removeAll()
            self.answerField.text = self.hiddenAnswer
            self.activatedButtons.forEach { $0.isHidden = false }
            self.activatedButtons.removeAll()
        }
    }
    
    func updateHiddenAnswer() {
        hiddenAnswer = ""
        
        for letter in correctAnswer {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                hiddenAnswer += strLetter
            } else {
                hiddenAnswer += "?"
            }
        }
        
        answerField.text = hiddenAnswer
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: loadNext))
        present(ac, animated: true)
    }
    
    func loadNext(action: UIAlertAction) {
        loadLevel()
        for button in letterButtons {
            button.isHidden = false
        }
    }
}
