//
//  Wordle.swift
//  Wordle
//
//  Created by Kousa, Yahya on 3/5/24.
//

import Foundation

class Wordle {
    
    var word: String = "" //correct word
    var guess: String = "" //supplied guess
    var dictionary : [String] = []
    var stateArray : [Int] = [] //array corresponding to the letters of the word, 0 = green, 1 = yellow, 2 = red
    var deadLetters : [Character] = [] //array corresponding to letters already used that aren't found within the word
    
    
    init() //initializes the dictionary
    {
        do {
           if let bundlePath = Bundle.main.path(forResource: "dictionary.txt", ofType: nil) {
               dictionary.append(contentsOf: try String(contentsOfFile: bundlePath).lowercased().components(separatedBy: "\n"))
           }
        } catch {
           print(error)
        }
        
        for str in dictionary
        {
            if str.count != 5
            {
                dictionary.remove(at: dictionary.firstIndex(of: str)!)
            }
        }
    }
    
    func grabWord() //picks a random word from the dictionary to be used at beginning of new game
    {
        word = dictionary.randomElement()!
        dictionary.remove(at: dictionary.firstIndex(of: word)!)
    }
    
    func wordChecker() //logic for comparing the guess to the correct word
    {
        var uniqueCharacters = Set(word)
        let wordChars : [Character] = Array(word)
        let guessChars : [Character] = Array(guess)
        for i in 0...4
        {
            if guessChars[i] == wordChars[i]
            {
                stateArray.append(0)
            }
            else if uniqueCharacters.contains(guessChars[i])
            {
                if countAppearance(char: guessChars[i], str: word) == 1
                {
                    uniqueCharacters.remove(guessChars[i])
                }
                stateArray.append(1)
            }
            else
            {
                if (deadLetters.firstIndex(of: guessChars[i]) == nil)
                {
                    deadLetters.append(guessChars[i])
                }
                stateArray.append(2)
            }
        }
        
    }
    
    func countAppearance(char: Character, str: String) -> Int {

       var counter = 0
       
       // Counting the occurrence of the
       // specified character
       for mChar in str {
          if mChar == char {
             counter += 1
          }
       }
       return counter
    }
    
    func deadLetterOutput() -> String
    {
        var str = ""
        for i in deadLetters
        {
            str.append("\(i.uppercased()), ")
        }
        return str
    }
    
    
    func resetGame()
    {
        grabWord()
        guess = ""
        deadLetters = []
        stateArray = []
    }


}

