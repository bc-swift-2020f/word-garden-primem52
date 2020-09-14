//
//  ViewController.swift
//  Word Garden
//
//  Created by Morgan Prime on 9/14/20.
//  Copyright © 2020 Morgan Prime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordsGuessedLabel: UILabel!
    
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    
    @IBOutlet weak var wordBeingRevealedLabel: UILabel!
    
    @IBOutlet weak var guessedLetterTextField: UITextField!
    
    @IBOutlet weak var guessedLetterButton: UIButton!
    
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let text = guessedLetterTextField.text!
        guessedLetterButton.isEnabled = !(text.isEmpty)
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        let text = guessedLetterTextField.text!
        guessedLetterButton.isEnabled = !(text.isEmpty)
    }
    func updateUIAfterGuess(){
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text! = ""
        guessedLetterButton.isEnabled = false
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        updateUIAfterGuess()
    }
    
    
    @IBAction func guessedLetterButtonPressed(_ sender: UIButton) {
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    
}




