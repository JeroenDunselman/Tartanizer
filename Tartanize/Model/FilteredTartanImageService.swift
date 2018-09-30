//
//  ColorFilteredTartanImageService.swift
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class FilteredTartanImageService: NSObject {
    var imageService: TartanImageService?
    var colorFilter = ColorFilteredTitleService()
    public let library = LibraryContents.shared.library
    
    override init() {
        super.init()
        self.imageService = TartanImageService(client: self) //
        self.colorFilter = ColorFilteredTitleService(client: self)
    }
    
    func assetTitlesForColorFilter() -> [String] {
        
        if let result: [String] = (imageService?.assetService.content
            .filter({asset in colorFilter.titlesInColorSet.contains(asset.entry.title)}) //
            .reduce([], {ar, el in return ar + [el.entry.title] }) ),
            result.count > 0 {
            //            print("assetTitles: \(imageService?.assetService.content.count ?? 0), ForCurrentColorFilter: \(result.count)")
            return result
        }
        
        //        print("NO assetTitles colorSet: \(self.colorFilter.colorSet)")
        return []
    }
    
    public func serveFreshTitleForColorFilter() -> String? {
        colorFilter.shuffleTitles()

//        if let result = colorFilter.titlesInColorSet.first(where: {filteredTitle in
//            !(self.imageService?.assetService.content
//                .compactMap({return $0.entry.title})
//                .contains(where: { $0 == filteredTitle}))!
//        }) { return result}

        if let result = colorFilter.titlesInColorSet.first(where: {filteredTitle in
            !(self.imageService?.assetService.contentTitles()
//                .compactMap({return $0 })
                .contains(where: { $0 == filteredTitle}))!
        }) { return result}
        
        return nil
    }
    
}


