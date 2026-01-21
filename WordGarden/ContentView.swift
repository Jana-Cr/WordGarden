//
//  ContentView.swift
//  WordGarden
//
//  Created by CRUZ, JANAI on 1/12/26.
//

import SwiftUI

struct ContentView: View {
    private static let maximumGuesses = 8
    
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusmessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0 //index in wordstoGuess
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = maximumGuesses
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another Word?"
    @FocusState private var textFieldIsFocused: Bool
    private let wordsToGuess = ["SWIFT", "PIANO", "EGG", "BLISS", "WEAPON", "FEELINGS", "DONT", "CALL", "ME", "ODASAKU", "NICEART"] //All gaps!!
    
    
    var body: some View {
        VStack {
            HStack{
            VStack (alignment: .leading){
                Text("Words Guessed: \(wordsMissed)")
                Text("Words Missed: \(wordsMissed)")
            }
                Spacer()
            VStack (alignment: .trailing){
                Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                Text("Words in Game: \(wordsToGuess.count)")
            }
        }
            Spacer()
            
            Text(gameStatusmessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            //TODO: switch to wordstoGuess[currentWordIndex]
            Text(revealedWord)
                .font(.title)
            
            if playAgainHidden {
                
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width:30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else{
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            //as longas guessedLetter is not an empty string, we can continue
                            guard guessedLetter != "" else{
                                return
                            }
                            guessALetter()
                            updateGamePlay()
                        }
                    
                    Button("Guess a Letter"){
                        guessALetter()
                        updateGamePlay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                
                Button(playAgainButtonLabel){
                    //if all the words have been guesssed
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    //reset after a word was guessed or missed
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    lettersGuessed = ""
                    guessesRemaining = Self.maximumGuesses //because maxiumumguesses is static
                    imageName = "flower\(guessesRemaining)"
                    gameStatusmessage = "How many Guesses to Uncover the Hidden Word"
                    playAgainHidden = true
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            

            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
            
            
        }
    func guessALetter(){
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord = wordToGuess.map{ letter in lettersGuessed.contains(letter) ? "\(letter)" : "_"}.joined(separator: " ")
        
    }
    
    func updateGamePlay(){
        if !wordToGuess.contains(guessedLetter){
            guessesRemaining -= 1
            imageName = "flower\(guessesRemaining)"
        }
        
        if !revealedWord.contains("_"){ //guessed when no "_" in revealed word
            gameStatusmessage = "You Guessed It! It Took You \(lettersGuessed.count) Guesses to Guess the Word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        }else if guessesRemaining == 0 { //word missed
            gameStatusmessage = "So Sorry, You're All Out of Guesses"
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else { //keep guessing
            gameStatusmessage = "You've Made \(lettersGuessed.count) Guess \(lettersGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusmessage = gameStatusmessage + "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
        
        guessedLetter = ""
    }
    
    }


#Preview {
    ContentView()
}
