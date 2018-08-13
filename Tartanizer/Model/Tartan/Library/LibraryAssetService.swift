//
//  LibraryAssetService.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class LibraryAssetService {
    static let shared = LibraryAssetService()
    
    var content:[Asset] = [] //    {        didSet {      print("content.count: \(content.count)")}} //publish
    var checkOut:[Entry] = []
    
    public func contentTitles() -> [String] {
        return content.reduce([]) {ar, el in ar + [el.entry.title] } 
    }
    
    init() {
        checkOut = LibraryContents.shared.publicContents // .library //.shared.library
    } // if content.count == 0 { createAsset()} }
    
    func threadCompletedFor(title : String) {
        //
        //        if let availableTitle = titleFromColorFilter() {
        //
        //
        //            //            if self.content.filter({$0.request.finished }).count < rowTitles.count + 1 {
        //            let maxSimultaneous = 4
        //            if self.content.filter({!$0.request.finished && $0.request.started}).count < maxSimultaneous {
        //                print("threadCompleted started \(availableTitle)")
        //                _ = contentFor(keyTitle: availableTitle, imageView: nil)
        //            } else {
        //                print("threadCompleted did not start next")
        //            }
        //        } else {
        //        print("threadCompletedFor \(title)")
        //        }
    }
    
    
    func createCustomAsset(from entry: Entry) -> Asset {
        
        //            let entry: Entry = checkOut.remove(at: checkOut.count.asMaxRandom())
        let request = ImageRequest(checkerBoard: LayOut(entry: entry))
        let asset: Asset = (entry: entry, request: request) //LayOut(tartan: entry.definition.tartan))
        let defaultImage = UIImage(color: UIColor.purple, size: CGSize(width: 200, height: 200))!
        asset.request.layOut.images["initial"] = defaultImage
        asset.request.downloadImage()
//        print("createAsset(from entry: \(asset.entry.title))")
        
        content.append(asset)
        return asset
    }
}




