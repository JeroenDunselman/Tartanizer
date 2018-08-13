//
//  extensions.swift
//  Tartanize
//
//  Created by Jeroen Dunselman on 11/08/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation

extension Int {
    
    //    minimum size to collage toPrime
    func toPrime() -> Int {
        var result = self
        while result % 2 == 0 {
            result = result / 2
        }
        return result
    }
    
    func colorPattern() -> [Int] {
        let seqs:[[Int]] = [[0], [0], [0, 1, 1], [0, 1, 2, 2], [0, 1, 2, 2, 3, 3, 3]]
        if self < seqs.count { return seqs[self]}
        return seqs[0]
    }
    
    func randomFib() -> Int {
        var fibonacci:Int = 0
        
        while fibonacci < 1 {
            
            let n = Double(self.asMaxRandom())
            fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) /
                2.23606).rounded())
        }
        return fibonacci
    }
    
    func asMaxRandom() -> Int {
        let maximum = self
        return Int({Int(arc4random_uniform(UInt32(maximum)))}())
    }
    
    func testIntExtension() {
        2.times {print("Hello, world")}
        //        2.down(to: 1) {i in print("\(i)..") }
        //        let isEven : Bool = 2.even(num: 3) print(isEven)
        //        4.up(to: 8) {  i in print("\(i)..")
    }
    
    func times (iterator: () -> Void) {
        for _ in 0..<self {iterator()}
    }
    
    func down (to : Int, iterator: (Int) -> Void) {
        var num : Int = self
        while num != to - 1 {
            iterator(num)
            num -= 1
        }
    }
    
    func up (to : Int, iterator: (Int) -> Void) {
        var num : Int = self
        while num != to + 1 {
            iterator(num)
            num += 1
        }
    }
    
    func even (num: Int) -> Bool {
        return self == num
    }
    
    func next () -> Int {
        return self + 1
    }
    
    func pred () -> Int {
        return self - 1
    }
    
}

extension Array where Element: Hashable {
    var valuedAsSet: Set<Element> {
        return Set<Element>(self)
    }
}

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
