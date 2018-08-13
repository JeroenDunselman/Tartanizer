//
//  ColorFilteredTartanImageService.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class FilteredTartanImageService: NSObject {
    var imageService: TartanImageService? //todo.shared
    var colorFilter = ColorFilteredTitleService()
    var patternFilter = PatternFilteredTitleService() //.base = imageservice
    public let library = LibraryContents.shared.library
    
    var dateString = ""
    
    override init() {
        super.init()
        self.imageService = TartanImageService(client: self) //
        self.colorFilter = ColorFilteredTitleService(client: self)
        self.patternFilter = PatternFilteredTitleService(client: self)
        //        self.imageService?.titleService = self
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        //            formatter.timeStyle = .
        dateString = formatter.string(from: Date())
    }
    
    func assetTitlesForColorFilter() -> [String] {
        
        if let result: [String] = (imageService?.assetService.content
            .filter({asset in colorFilter.titlesInColorSet.contains(asset.entry.title)}) //
            .reduce([], {ar, el in return ar + [el.entry.title] }) ) {
            if result.count > 0 {
                print("assetTitles: \(imageService?.assetService.content.count ?? 0), ForCurrentColorFilter: \(result.count)")
                return result
            }
        }
        
        print("NO assetTitles colorSet: \(self.colorFilter.colorSet)")
        return []
    }
    
    public func serveTitleFromFilter() -> String? {
        return serveFreshTitleForColorFilter()
    }
    
    public func serveFreshTitleForColorFilter() -> String? {
        colorFilter.shuffleTitles()
        
        return colorFilter.titlesInColorSet.first(where: {filteredTitle in
            !(self.imageService?.assetService.content.contains(where: { $0.entry.title == filteredTitle}))!})
    }
    
    public func serveFreshTitleForPatternFilter() -> String? { //**niu
        patternFilter.filterTitlesForPattern()
        
        return patternFilter.titlesFiltered.first(where: {filteredTitle in
            !(self.imageService?.assetService.content.contains(where: { $0.entry.title == filteredTitle}))!})
    }
    
    
    //        typealias TartanDefinition = (tartan: Tartan, info: [String:Any])
    //        typealias Entry = (title: String, definition: TartanDefinition?)
    //        typealias Asset = (entry: Entry, request: AssetRequest)
    
    func patternVariationsFromLibrary(of exampleLayOut: LayOut, maxCount: Int) -> [LayOut]? {
        var result: [LayOut] = []
        
//        exampleLayOut.tartan?.createColorPattern()
        print("looking for pattern \(exampleLayOut.tartan?.colorSetCompact.sortString ?? "sortstring_n.a.")")
        
        
        
        let signature = "patternVariationsFromLibrary"
        var entry: Entry = (title: "\((exampleLayOut.tartan?.colorSetCompact.sortString)!)))",
                            definition: (tartan: exampleLayOut.tartan!,
                                         info: ["creation" :
                                            ["createdBy":"\(signature)",
                                             "createdOn":"\(Date.description(Date()))"]]))
        patternFilter.seed = entry //..?
        patternFilter.filterTitlesForPattern()
        
//        _ = patternFilter.titlesFiltered.map()
        
        let entriesForLayOutMatch: [Entry] = patternFilter.base
                        .filter({$0.definition?.tartan.colors.count == exampleLayOut.tartan?.colors.count})
                        .filter({$0.definition?.tartan.colorSetCompact.sortString == exampleLayOut.tartan?.colorSetCompact.sortString})
                        .filter({!(imageService?.assetService.contentTitles().contains($0.title))!})
//            patternFilter.titlesFiltered.map({print("\(self. library[$0])")})
//            .filter({$0.definition?.tartan.colors.count == exampleLayOut.tartan?.colors.count})
//            .filter({!(imageService?.assetService.contentTitles().contains($0.title))!})


        _ = entriesForLayOutMatch.map({
            
            _ = imageService?.contentFor(keyTitle: $0.title, imageView: nil)
            print("Pattern/Colorcount Match started img \($0.title)")

            let d: TartanDefinition = $0.definition!
            entry = (title: "\($0.title).\(dateString)",
                definition: (tartan: d.tartan, info: (entry.definition?.info)!))
            
            entry.definition?.tartan.colors = (exampleLayOut.tartan?.colors)! //($0.definition?.tartan.sizes)!
            
            let keyTitle: String = "\((exampleLayOut.tartan?.colors)!)" //.reduce("") { ar, el in "\(ar!)\(el)" })!
            entry.title = "\(entry.title).\(keyTitle)"
            
            let custom = imageService?.assetService.createCustomAsset(from: entry)
            //                    return entry //
            result.append((custom?.request.layOut)!)
            
            print("img started ForLayOutMatch \(custom?.entry.title ?? "title_NA")")

        })
        //        }
        
        
        
        self.patternFilter.seed = entry
        print("found patternFilter: \(patternFilter.titlesFiltered.count )")
        
        
        
        
        //any finished?
        _ = imageService?.assetService.content.filter({asset in
            exampleLayOut.tartan?.colorSetCompact.sortString == asset.entry.definition?.tartan.colorSetCompact.sortString
                && asset.request.finished})
            .map({
                result.append($0.request.layOut)
                //                print("asset for patternFilter found: \($0.entry.title)")
            })
        
//        //create?
//        while result.count < maxCount,
//            let title = patternFilter.titlesFiltered
//                .filter({t in (imageService?.assetService.checkOut.contains(where: {asset in t == asset.title}))!})
//                .first,
//            
//            let requestForFilter: Asset = imageService?.contentFor(keyTitle: title, imageView: nil) {
//                //                    add board
//                result.append(requestForFilter.request.layOut)
//                print("createPatternVariationsFromExample: \(title )")
//        }
        
        return result
    }
    
    func colorVariationsFromLibrary(of board: LayOut, maxCount: Int) -> [LayOut]? {
        var result: [LayOut] = []
        
        //  try any assets for colors
        _ = imageService?.assetService.content
            .filter({asset in board.colorSet.isSubset(of: (asset.entry.definition?.tartan.colorSet)!)})
            //            .filter({$0.request.finished})
            .map({
                
                result.append($0.request.layOut)
                                print("asset for colorSet found: \($0.entry.title) \($0.entry.definition?.tartan.colorSet ?? [])")
            })
        
        //  else create new for colors //colors: (board.tartan?.colorSet)!
        //        colorFilter.colorSet = (board.tartan?.colorSet)!
        //        colorFilter.filterTitlesForColorSubset()
        while let title = colorFilter.titlesInColorSet
            .filter({t in (imageService?.assetService.checkOut.contains(where: {asset in t == asset.title}))!})
            .first,
            let requestFilterResult: Asset = imageService?.contentFor(keyTitle: title, imageView: nil),
            result.count < maxCount {
                
                result.append(requestFilterResult.request.layOut)
                print("ColorVariation result \(result.count): \(title ) \(requestFilterResult.entry.definition?.tartan.colorSet ?? [])")
        }
        return result
    }
}


