//
//  ColorFilteredTartanTitleService.swift
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class ColorFilteredTitleService: NSObject {
    
    public var colorSet: Set<Int> = [] //{didSet { print("colorSet didSet \(colorSet)")}}
    var titlesInColorSet: [String] = []
    
    var client: FilteredTartanImageService?
    var base: [Entry]?

    convenience init(client: FilteredTartanImageService) {
        self.init()
        self.client = client
        self.base = client.library //imageService?.assetService //LibraryContents.shared.library
        self.titlesInColorSet = base!.reduce([], {ar, el in return ar + [el.title] })
    }
    
    public func insert(color: Int) {
        print("")
        print("TitleService insert \(color) to colorSet: \(colorSet)")
        colorSet.insert(color)
        
        filterTitlesForColorSubset()
    }
    
    public func filterTitlesForColorSubset() {
        let entryTitles = base!
            .filter({colorSet.isSubset(of:  $0.definition!.tartan.colorSet)})
            .reduce([], {ar, el in return ar + [el.title] })
        
        if entryTitles.count == 0 {
            print("no filter titles for \(colorSet)  ")
        } else {
//            print("filterTitlesForColorSubset: \(colorSet) titles: \(titlesInColorSet.count)")
            self.titlesInColorSet = entryTitles
        }
    }
    
    public func resetFilter() { // -> [String] {
        
        colorSet = []
        self.titlesInColorSet = LibraryContents.shared.publicTitles
        
//        print("!!resetColorFilter titlesInColorSet: \(titlesInColorSet.count)")
    }
    
    public func shuffleTitles() { titlesInColorSet.shuffle()}
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

