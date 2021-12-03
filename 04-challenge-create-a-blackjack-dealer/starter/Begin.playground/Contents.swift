import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Create a Blackjack card dealer") {
  let dealtHand = PassthroughSubject<Hand, HandError>()
  
  func deal(cards cardCount: UInt) {
    var deck = cards
    var cardsRemaining = 52
    var hand = Hand()
    
    for _ in 0 ..< cardCount {
      let randomIndex = Int.random(in: 0 ..< cardsRemaining)
      hand.append(deck[randomIndex])
      deck.remove(at: randomIndex)
      cardsRemaining -= 1
    }
    
    // Add code to update dealtHand here
    if hand.points > 21 {
      dealtHand.send(completion: .failure(.busted))
    } else {
      dealtHand.send(hand)
    }
  }
  
  // Add subscription to dealtHand here
  dealtHand
    .sink { error in
//      Method 1: Iterate through all sink result cases:
//      switch(result) {
//      case .failure(let error):
//        print(error)
//      case .finished:
//        print("Finished")
//      }
      
//       Method 2: Handle any publisher failure and print error text:
      if case .failure(let error) = error {
        print(error)
      }
      
    } receiveValue: { hand in
      print(hand.cardString, "for", hand.points, "points.")
    }
    .store(in: &subscriptions)
  
  deal(cards: 3)
}

/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
