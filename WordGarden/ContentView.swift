//
//  ContentView.swift
//  WordGarden
//
//  Created by CRUZ, JANAI on 1/12/26.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusmessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var currentWordIndex = 0 //index in wordstoGuess
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    private let wordsToGuess = ["SWIFT", "PIANO", "EGG","BLISS", "WEAPON", "FEELINGS", "DONT", "CALL", "ME", "ODASAKU", "NICEART"] //All gaps!!
    
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
                        }
                    
                    Button("Guess a Letter"){
                        guessALetter()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                
                Button("Another Word?"){
                    
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
        guessedLetter = ""
    }
    }


#Preview {
    ContentView()
}
