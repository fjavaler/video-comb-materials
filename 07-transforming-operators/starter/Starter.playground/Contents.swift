import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Collect") {
  // Turn Array into publisher and subscribe to it.
  ["A","B","C","D","E"].publisher
  //   Collects every element in the array and combines them into one output array.
  //   Similar to how flatMap does this.
    .collect()
  //   Collect two elements at a time and puts them into an array.
  //    .collect(2)
    .sink {
      // If subscription receives a completion...
      print($0)
    } receiveValue: {
      // If subscription receives a value...
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator (map)") {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  
  [123, 4, 56].publisher
    .map {
      // "return" optional.
      return formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
    }
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator (replaceNil)") {
  ["A", nil, "C"].publisher
    .replaceNil(with: "-")
    .map({ string in
      // "return" optional.
      return string!
    })
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator [replaceEmpty(with:)]") {
  let empty = Empty<Int, Never>()
  
  empty
    .replaceEmpty(with: 1)
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator (scan)") {
  var dailyGainLoss: Int {
    Int.random(in: -10...10)
  }
  
  let august2019 = (0..<31)
    .map { _ in
      return dailyGainLoss
    }
    .publisher
  
  august2019
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .print()
    .sink { _ in
      // Do nothing.
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator (easier to comprehend example of scan)") {
  [1,2,3,4,5,6].publisher
    .scan(1, { num1, num2 in
      num1 + (num1 + num2)
    })
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
}

example(of: "Transforming operator (flatMap)") {
  let charlotte = Chatter(name: "Charlotte", message: "Charlotte: Hi, I'm Charlotte!")
  let james = Chatter(name: "James", message: "James: Hi, I'm James!")
  
  // Publisher. Sets chat.value to charlotte
  let chat = CurrentValueSubject<Chatter, Never>(charlotte)
  
  // Subscribes to value to map and prints.
  chat
    .flatMap({
      $0.message
    })
    .sink {
      print($0)
    }
    .store(in: &subscriptions)
  
  // Updates charlotte.message.value. .message is the value that we are subscribed to.
  // Therefore, prints value per sink block above.
  charlotte.message.value = "Charlotte: How's it going?"
  
  // Add's Chatter, james, to chat's value. Flatmap, sink, and store block now applies
  // to chat.value of James as well.
  chat.value = james
  
  // Updates james.message.value and prints per sink block.
  james.message.value = "James: Doing great. You?"
  // Updates charlotte.message.value and prints per sink block.
  // Notice both james.message.value and charlotte.message.value are both subscribed to
  // simulataneously now.
  charlotte.message.value = "Charlotte: I'm doing fine, thanks."
}

/// Copyright (c) 2020 Razeware LLC
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
