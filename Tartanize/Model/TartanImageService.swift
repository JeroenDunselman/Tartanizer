//
//  TartanImageService.swift
//
//  Created by Jeroen Dunselman on 04/08/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//
//

import Foundation
import UIKit

class TartanImageService {
    let assetService = LibraryAssetService.shared
    public var titleService: FilteredTartanImageService?
    
    init(client: FilteredTartanImageService) {
        self.titleService = client
    }
    
    func contentFor(keyTitle: String, imageView: UIImageView?) -> Asset? {
        
        if keyTitle == "" {
            
            //try return unclaimed finished
            var index: Int?
            for entry in assetService.checkOut {
                
                if let unclaimedTitle = (self.assetService.content
                    .filter({$0.request.finished })
                    .first(where: {entry.title == $0.entry.title})?.entry.title) {
                    
                    index = assetService.checkOut.index(where: {$0.title == unclaimedTitle})
                    break
                }
            }
            
            if let titleFoundAt = index {
                let claim: Entry = assetService.checkOut.remove(at: titleFoundAt)
                return assetService.content.first(where: {$0.entry.title == claim.title})
            }
            
        }
        
        //  title requested?
        if let assetForTitle: Asset = self.assetService.content.first(where: {$0.entry.title == keyTitle}) {
            //  update imageview
            if let currentView = imageView {
                assetForTitle.request.imageView = currentView
            }
            
            return assetForTitle
        }
        
        //      check out requested Entry
        if let index = assetService.checkOut.index(where: {$0.title == keyTitle}),
            let claim = assetService.checkOut.remove(at: index) as Entry?,
            let asset = (Asset(entry: claim, request: ImageRequest(checkered: LayOut(entry: claim), service: self.assetService))) as Asset? {
            
            if let currentView = imageView {
                asset.request.imageView = currentView
            }
            asset.request.downloadImage()
            assetService.content.append(asset)
            return asset
        }
        
        if let newTitle = self.titleService?.serveFreshTitleForColorFilter(){
            //            print("contentFor(newTitle: \(newTitle))")
            return contentFor(keyTitle: newTitle, imageView: nil)
        }

        return nil
    }
}
