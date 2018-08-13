//
//  ColorFilteredTartanTitleService.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class PatternFilteredTitleService: NSObject {
    var base: [Entry] = []
    var titlesFiltered: [String] = []
    var client: FilteredTartanImageService?
    
    public var seed: Entry = (title: "", definition: nil)
    //    {
    //        didSet {
    //            print("\n seed is nu \(seed.title).")
    //            let criterium: String = (seed.definition?.tartan.colorLayOut.sortString)!
    //            titlesFiltered = base
    //                .filter({$0.definition?.tartan.colorLayOut.sortString == criterium})
    //                  .reduce([]){ar, el in ar + [el.title] }
    ////                .map({ print("\($0.title)") })
    //            print("criterium: \(criterium) found: \(titlesFiltered.count)")
    //        }
    //
    //    }
    
//    override init() {
//        super.init()
//        //        self.base = LibraryContents.shared.library
//    }
    
    convenience init(client: FilteredTartanImageService) {
        self.init()
        self.client = client
        self.base = client.library //imageService?.assetService //LibraryContents.shared.library
        
    }
    
    public func filterTitlesForPattern() {
        
        let entryTitles = base
            .filter({$0.definition?.tartan.colorSetCompact.sortString == seed.definition?.tartan.colorSetCompact.sortString})
            .reduce([], {ar, el in return ar + [el.title] })
        
        guard entryTitles.count > 0 else {
            print("no titles for pattern \(seed.definition?.tartan.randomContrastFib() ?? 0)  ")
            return
        }
        
        self.titlesFiltered = entryTitles
        
        print("filterTitlesForPattern: \(seed.definition?.tartan.randomContrastFib() ?? 0) titles: \(titlesFiltered.count)")
    }
    
    public func resetFilter() { // -> [String] {
        self.titlesFiltered = LibraryContents.shared.publicTitles
        
        print("!!resetPatternFilter titles: \(titlesFiltered.count)")
        //        return titlesInColorSet
    }
    
    
}

class ColorFilteredTitleService: NSObject {
    
    public var colorSet: Set<Int> = [] //{didSet { print("colorSet didSet \(colorSet)")}}
    var titlesInColorSet: [String] = []
    
    var client: FilteredTartanImageService?
    var base: [Entry]?
    //    FilteredTartanImageService
//    override init() {
//
//        self.base = LibraryContents.shared.library
//
//        super.init()
//
//        //        colorSet.insert(Palet.shared.indexOfColor(color: UIColor.cyan)!)
//        //        filterTitlesForColorSubset()
//        self.titlesInColorSet = base!.reduce([], {ar, el in return ar + [el.title] })
//    }
    
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
            print("filterTitlesForColorSubset: \(colorSet) titles: \(titlesInColorSet.count)")
            self.titlesInColorSet = entryTitles
        }
    }
    
    public func resetFilter() { // -> [String] {
        
        colorSet = []
        self.titlesInColorSet = LibraryContents.shared.publicTitles
        
        print("!!resetColorFilter titlesInColorSet: \(titlesInColorSet.count)")
        //        return titlesInColorSet
    }
    
    //    public func titles(colorSet: Set<Int>) -> [String?] {
    ////        let base = library.checkOut() //.contents
    //        let entries: [Entry] = base!.filter({$0.definition.tartan.colorSet == colorSet})
    //        return entries.reduce([], {ar, el in return ar + [el.title] })
    //    }
    
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

