//
//  ViewController.swift
//  Word Garden
//
//  Created by Morgan Prime on 9/14/20.
//  Copyright © 2020 Morgan Prime. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    
    
    var wordsToGuess = ["SWIFT", "DOG","CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    
    var audioPlayer: AVAudioPlayer!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let text = guessedLetterTextField.text!
        guessedLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        
        updateGameStatusLabels()
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessedLetterButton.isEnabled = !(sender.text!.isEmpty)
    }
    func updateUIAfterGuess(){
        guessedLetterTextField.resignFirstResponder()
        guessedLetterTextField.text! = ""
        guessedLetterButton.isEnabled = false
    }
    
    func formatRevealedWord(){
        var revealedWord = " "
                     
         for letter in wordToGuess{
             if lettersGuessed.contains(letter){
                 revealedWord = revealedWord + "\(letter)"
             }
             else{
                 revealedWord = revealedWord + "_ "
             }
         }
         revealedWord.removeLast()
         wordBeingRevealedLabel.text = revealedWord

        
    }
    
    func updateAfterWinOrLose() {
        currentWordIndex += 1
        guessedLetterTextField.isEnabled = false
        guessedLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        updateGameStatusLabels()
        
          
    }
    
    func updateGameStatusLabels(){
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words to Guess: \(wordsToGuess.count - (wordsGuessedCount - wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
    }
      
    func drawFlowerAndPlaySound(currentLetterGuessed: String){
        if wordToGuess.contains(currentLetterGuessed) == false{
            wrongGuessesRemaining = wrongGuessesRemaining - 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "wilt\(self.wrongGuessesRemaining)")}) { (_) in
                    
                    if self.wrongGuessesRemaining != 0{
                        self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                    }
                    else {
                        self.playSound(name: "word-not-guessed")
                        UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")}, completion: nil)
                    }
                    //to do change to next flower number
                }
                self.playSound(name: "incorrect")
            }
            
        }
       else{
           playSound(name: "correct")
       }
    
    }
    func guessALetter(){
        //get currentLettersguessed and add it to all letters guessed
        let currentLetterGuessed = guessedLetterTextField.text!
        lettersGuessed = lettersGuessed + currentLetterGuessed
        
        formatRevealedWord()
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
   
        
        let guesses = (guessCount == 1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guesses)"
        
        if wordBeingRevealedLabel.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've Guessed it.  It took you \(guessCount) guesses to guess the word."
            wordsGuessedCount += 1
            playSound(name: "word-guessed")
            updateAfterWinOrLose()
            
        }
        else if wrongGuessesRemaining == 0 {
            gameStatusMessageLabel.text = "So sorry out of guesses"
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        
        if currentWordIndex == wordsToGuess.count {
            gameStatusMessageLabel.text! +=  "\n\nYou've tried all of the words! Restart?"
            
        }
        
    }
    
    func playSound(name: String){
        if let sound = NSDataAsset(name : name){
            do{
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            }
            catch{
                print("ERROR: \(error.localizedDescription). Could not initialize AVAudioPlayer Object")
            }
        }
        else{
            print("Could not read data from file \(name)")
        }
    }
    
  
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    
    @IBAction func guessedLetterButtonPressed(_ sender: UIButton) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        if currentWordIndex == wordToGuess.count{
            currentWordIndex = 0
            wordsMissedCount = 0
            wordsGuessedCount = 0
        }
        
        playAgainButton.isHidden = true
        guessedLetterTextField.isEnabled = true
        guessedLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        wordBeingRevealedLabel.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower\(maxNumberOfWrongGuesses)")
        lettersGuessed = " "
        updateGameStatusLabels()
        gameStatusMessageLabel.text = "You've Made 0 Guesses"
        
        
        
    }
    
}




