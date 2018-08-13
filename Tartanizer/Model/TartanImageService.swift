//
//  TartanImageService.swift
//  pvc holadijee
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
        //        print("keyTitle searched \(keyTitle)")
        if keyTitle == "" {
            
            //try return unclaimed finished
            var index: Int?
            for entry in assetService.checkOut {
                if let unclaimedTitle = (self.assetService.content.filter({$0.request.finished }).first(where: {entry.title == $0.entry.title})?.entry.title) {
                    
                    index = assetService.checkOut.index(where: {$0.title == unclaimedTitle})
                    //First({$0.title == unclaimedTitle} )as Entry?
                    break
                }
                
            }
            
            if let foundIndex = index {
                let claim: Entry = assetService.checkOut.remove(at: foundIndex)
                return assetService.content.first(where: {$0.entry.title == claim.title})
            }
            
        }
        
        //        title requested?
        if let assetForTitle = self.assetService.content.first(where: {$0.entry.title == keyTitle}) {
            //  view needs update?
            if let currentView = imageView {
                assetForTitle.request.imageView = currentView
            }
            return assetForTitle
            
        }
        
        //      check out Entry to content for requested title
        if let index = assetService.checkOut.index(where: {$0.title == keyTitle}) as Int?,
            let claim = assetService.checkOut.remove(at: index) as Entry?,
            let asset = (Asset(entry: claim, request: ImageRequest(checkerBoard: LayOut(entry: claim), service: self.assetService))) as Asset? {
            
            //            let defaultImage = UIImage(color: UIColor.red, size: CGSize(width: 200, height: 200))!
            //            asset.request.checkerBoard.images["initial"] = defaultImage
            
            if let currentView = imageView {
                asset.request.imageView = currentView //downloadImage(imageView: currentView)
            }
//            print("starting img \(asset.entry.title)")
            asset.request.downloadImage()
            //
            
            assetService.content.append(asset)
            return asset
        }
        
        if let newTitle = self.titleService?.serveTitleFromFilter(){
            //            print("contentFor(newTitle: \(newTitle))")
            return contentFor(keyTitle: newTitle, imageView: nil)
        }
        
        let defaultTitle = "Stewart (Ancient)"
        if let asset = contentFor(keyTitle: defaultTitle, imageView: imageView) {
            
            return asset
        }
        
        return nil
    }
}
