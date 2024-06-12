//
//  ViewController.swift
//  Wordle
//
//  Created by Kousa, Yahya on 2/20/24.
//

import UIKit

class ViewController: UIViewController {
    
    var game : Wordle = Wordle()
    
    @IBOutlet var textField: textField!
    
    var letterCount = 0
    
    let allowedChars = Set("abcdefghijklmnopqrstuvwxyz")
    
    @IBOutlet var deadLettersLabel: UILabel!
    
    @IBOutlet var labels: [LetterTile]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let interfaceStyle = window?.overrideUserInterfaceStyle  == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if let mode = UserDefaults.standard.value(forKey: "mode") as? String
        {
            if mode == "dark"
            {
                window?.overrideUserInterfaceStyle = .dark
            }
            else
            {
                window?.overrideUserInterfaceStyle = .light
            }
        }
        
        
        game.grabWord()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func guessInput(_ sender: UITextField) {
        guard sender.text!.count == 5 && Set(sender.text!).isSubset(of: allowedChars) && game.dictionary.firstIndex(of: sender.text!) != nil else {textField.shake(); return}

        game.guess = sender.text!
        textField.text = ""
        let guess = game.guess.uppercased()
        let guessChars = Array(guess)
        game.wordChecker()
        for i in 0...4
        {
            UIView.transition(with: labels[i + self.letterCount], duration: 0.75, options: [.transitionFlipFromTop], animations: nil)

            if game.stateArray[i] == 0
                {
                    labels[i + letterCount].backgroundColor = .systemGreen
                }
                else if game.stateArray[i] == 1
                {
                    labels[i + letterCount].backgroundColor = .systemYellow
                }
                else
                {
                    labels[i + letterCount].backgroundColor = .systemGray
                }
                labels[i + letterCount].text = String(guessChars[i])

        }
        game.stateArray.removeAll()
        
        deadLettersLabel.text = game.deadLetterOutput()
        
        letterCount += 5

        if letterCount >= 30
        {
            let alert = UIAlertController(title: "You suck!", message: "Correct word was: \(game.word)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Play again?", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    self.game.resetGame()
                    self.deadLettersLabel.text = ""
                    for i in 0...self.labels.count - 1
                    {
                        self.labels[i].backgroundColor = .systemGray
                        self.labels[i].text = ""
                    }
                    case .cancel:
                    break
                    case .destructive:
                    break
                }
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    exit(0)
                    case .cancel:
                    break
                    case .destructive:
                    break
                }
            }))
            self.present(alert, animated: true, completion: nil)
            letterCount = 0
        }
    }
    
    @IBAction func toggleModeButton(_ sender: Any) {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let interfaceStyle = window?.overrideUserInterfaceStyle  == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if interfaceStyle != .dark {window?.overrideUserInterfaceStyle = .dark; UserDefaults.standard.setValue("dark", forKey: "mode")} else {window?.overrideUserInterfaceStyle = .light; UserDefaults.standard.setValue("light", forKey: "mode")}
    }
    
    @IBAction func helpButton(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: self)
    }
}

