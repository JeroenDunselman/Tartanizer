//
//  TartanLibrary.swift
//
//  Created by Jeroen Dunselman on 24/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation

class LibraryContents: NSObject {
    static let shared = LibraryContents()
    
    public let library: [Entry] = TartanLibrary.shared.contents //.checkOutPublicContents()
    public var publicTitles: [String] = []
    public var publicContents: [Entry] = []
    
    func checkOutPublicContents() {
        publicContents = library
            .filter({($0.definition?.tartan.colors.count)! < 7 })
        publicTitles = publicContents.reduce([], {ar, el in return ar + [el.title] })
//        analyzePublicContents()
    }
    
    override init() {
        super.init()
        self.checkOutPublicContents()
        print("checkOut() \(publicTitles.count) titles")
    }
    
    var patternCollection: Set<String> = []
    var patterns: [String:Int] = [:]
    func analyzePublicContents() { //

        _ = publicContents
            .sorted(by: {($0.definition?.tartan.colorSetCompact.layOut.count)! < ($1.definition?.tartan.colorSetCompact.layOut.count)!})
            .sorted(by: {($0.definition?.tartan.colorSetCompact.sortString)! < ($1.definition?.tartan.colorSetCompact.sortString)!}) //
            .map({

                patternCollection.insert(($0.definition?.tartan.colorSetCompact.sortString)!)
            })
        _ = Array(patternCollection)
            .map({p in patterns[p] = publicContents
            .filter({$0.definition?.tartan.colorSetCompact.sortString == p}).count})
        _ = patterns
            .filter({$0.value > 1})
            .sorted(by: {$1.key.count < $0.key.count})
            .map({print("\($0.key): \($0.value) ")})

        print("patterns.count: \(patterns.count)")
    }
}

class TartanLibrary: NSObject {
    
    let input = ParsedTextFile()
    static let shared = TartanLibrary()
    
    public var dictionary: [String: TartanDefinition] = [:]
    public var contents: [Entry] = []
    
    private override init() {
        super.init()
        parseInput()
    }
    
    func parseInput() {
        
        var sizesSet: Set<Int> = []
        let palet = Palet.shared
        
        dictionary = input.contentsOfTextFile.reduce([String: TartanDefinition]())
        { (dict, content) -> [String: (tartan: Tartan, info: [String:Any])] in
            var dict = dict
            var tartanInfo: [String: Any] = [:]
            
            tartanInfo["definition"] = content.definition
            
            let zones = (tartanInfo["definition"] as! String).components(separatedBy: ",")
            //**sizes
            let sizes = zones.reduce([]) {
                (result, zone) in result + [Int(zone
                    .components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined(separator: ""))]}
            
            if let availableSizes = sizes as? [Int] {
                
                sizesSet = sizesSet.union(Set(availableSizes))

                //**colors
                let colorStrings:[String] = zones.reduce([]) {
                    (result, zone) in result +
                        [zone.components(separatedBy: CharacterSet.decimalDigits)
                            .joined(separator: "")
                            .trimmingCharacters(in: .whitespaces)
                            .replacingOccurrences(of: "\t", with: "")] }
                
                var entry: TartanDefinition
                if let availableMap = colorStrings.reduce([], { ar, el in ar + [palet.colorMap[el]?.0] }) as? [Int] {
                    
                    entry.tartan = Tartan(colors: availableMap, sizes: availableSizes)
                    entry.info = tartanInfo
                    
                    //postfix for existing key
                    var uniqueTitle = content.title
                    while dict[uniqueTitle] != nil {
                        uniqueTitle = uniqueTitle + ".x"
                    }
                    
                    dict[uniqueTitle] = entry
                }
            }
            
            return dict
        }

        self.contents = dictionary.reduce([Entry](), {ar, el in return ar + [(title: el.key, definition: el.value)] })
    }
}

struct ParsedTextFile {
    var titles:[String] = []
    var definitions:[String] = []

    var contentsOfTextFile:[(title: String, definition: String)] = []
    
    init() {
        //    parse this file
        let path = Bundle.main.path(forResource: "tartandefs elements as row", ofType: "rtf")
        
        let contents: NSString
        do {contents = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {contents = "" }
        
        let components = contents.components(separatedBy: "\n");
        let tartans:[String] = components.reduce([]) {
            (result, zone) in result +
                [zone.replacingOccurrences(of: "\\", with: "")
                    .replacingOccurrences(of: "\t", with: "")]
        }
        
        for i in stride(from: 9, through: 2307, by: 3) {
            titles.append(tartans[i])
        }
        for i in stride(from: 11, through: 2306, by: 3) {
            definitions.append(tartans[i])
        }
        
        //todo test ar.counts
        contentsOfTextFile = (0..<definitions.count).reduce([]) {ar, el in ar + [(title: self.titles[el], definition: self.definitions[el])]}
    }
}
