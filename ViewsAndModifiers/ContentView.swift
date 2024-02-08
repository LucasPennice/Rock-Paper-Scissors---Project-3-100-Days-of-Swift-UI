//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Lucas Pennice on 08/02/2024.
//

import SwiftUI

enum Strat : String, CaseIterable{
    case win,loose
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> Strat {
        return Strat.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> Strat {
        var g = SystemRandomNumberGenerator()
        return Strat.random(using: &g)
    }
    
}

enum Move : String, CaseIterable{
    case rock, paper, scissors
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> Move {
        return Move.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> Move {
        var g = SystemRandomNumberGenerator()
        return Move.random(using: &g)
    }
}

let turns = 5

func getComputerHand() -> (Strat, Move){
    return (Strat.random(), Move.random())
}

struct ComputerPick : View{
    let computerPick : String
    
    var iconName : String {
        if computerPick == Move.scissors.rawValue {return "scissors"}
        if computerPick == Move.rock.rawValue {return "mountain.2"}
        return "newspaper"
    }
    
    @ViewBuilder var body : some View{
        Text("The computer has picked:")
        
        HStack{
            Image(systemName: iconName)
            Text(computerPick.capitalized)
        }
        
    }
}

struct Score : View {
    let score : [Strat]
    
    func getColor(scoreIdx: Int) -> Color {
        let outOfBounds = scoreIdx > score.endIndex - 1
        
        if outOfBounds {return .gray}
        
        if score[scoreIdx] == .win {return .green}
        return .red
    }
    
    @ViewBuilder var body: some View {
        HStack{
            ForEach(0..<turns, id: \.self){ idx in
                Circle()
                    .fill(getColor(scoreIdx: idx))
                    .frame(width: 30)
            }
        }
        
    }
}

struct ContentView: View {
    @State private var score : [Strat] = []
    @State private var hand : (Strat, Move) = getComputerHand()
    
    func selectOption (_ tappedOption : Move){
        let computedSelection = hand.1
        
        if (tappedOption == .paper && computedSelection == .rock ||
            tappedOption == .rock && computedSelection == .scissors ||
            tappedOption == .scissors && computedSelection == .paper) {
            updateScore(didWin: true)
        }else{
            updateScore(didWin: false)
        }
        
        return randomizeHand()
    }
    
    func updateScore(didWin:Bool){
        if (didWin == true && hand.0 == .win ||
            didWin == false && hand.0 == .loose ){return score.append(.win)}
    
        return score.append(.loose)
    }
    
    func randomizeHand(){
        hand = getComputerHand()
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.gray,.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                if score.count != turns {
                    Text("On this turn you need to:")
                    Text("\(hand.0.rawValue.capitalized)")
                        .font(.largeTitle.bold())
                    
                    ComputerPick(computerPick: hand.1.rawValue)
                    
                    VStack(spacing:30){
                        Button("Rock",systemImage: "mountain.2"){selectOption(.rock)}
                        Button("Paper",systemImage: "newspaper"){selectOption(.paper)}
                        Button("Scissors",systemImage: "scissors"){selectOption(.scissors)}
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.largeTitle)
                } else{
                    Text("Your Score is")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                }
               
                
                Score(score: score)
            }
            .padding(30)
            .background(.thinMaterial)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ContentView()
}

