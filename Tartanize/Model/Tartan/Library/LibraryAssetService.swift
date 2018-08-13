//
//  LibraryAssetService.swift
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class LibraryAssetService {
    static let shared = LibraryAssetService()
    
    var content:[Asset] = []
    var checkOut:[Entry] = []
    
    public func contentTitles() -> [String] {
        return content.reduce([]) {ar, el in ar + [el.entry.title] } 
    }
    
    init() {
        checkOut = LibraryContents.shared.publicContents
    }
    
}




