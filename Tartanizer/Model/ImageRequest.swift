
//  Created by Jeroen Dunselman on 02/04/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit

class ImageRequest : NSObject {
    var imageView: UIImageView?
    
    var service: LibraryAssetService?
    var started: Bool = false
    var finished: Bool = false
    var assignedToRow: Int?
    var exposed: Bool = false //todo move to asset
    
    public var layOut: LayOut!
    
    init(checkerBoard board: LayOut) {
        //        url = URL(string: gifLocation)
        //        board = Checkerbo ard(withRandomSizesFor: anagram) //.startImage()
        self.layOut = board
    }

    init(checkerBoard board: LayOut, service: LibraryAssetService) {
        self.layOut = board
        self.service = service
    }
    
    func finish() {
        self.finished = true
        let v = (self.imageView != nil) ? "view" : ""
        self.service?.threadCompletedFor(title: "\(v) \((self.layOut.entry?.title)!)")
    }

    func downloadImage() { //imageView: UIImageView?) {
        guard !self.started else {
            return
            
        }
        
        var image = UIImage()
        DispatchQueue.global(qos: .background).async {
//            print("startImage: \((self.checkerBoard.entry?.title)!), \(self.checkerBoard.entry?.definition.tartan.colorSet ?? [])")
            
            self.started = true
            image = self.layOut.startImage()
            
            self.finish()
            if  self.imageView != nil {
                DispatchQueue.main.async() { () -> Void in
                    
                    //  Update view once downloaded.
                    self.imageView?.image = image
                    self.exposed = true
//                    self.finished = true
                }
            }
            
//            self.finished = true
//            print("finishedImage: \((self.checkerBoard.entry?.title)!)")
        }
    }

}
//    init(colors anagram: [Int]) {
//        //        url = URL(string: gifLocation)
//        checkerBoard = LayOut(withRandomSizesFor: anagram) //.startImage()
//    }
//  init(gifLocation: String) {
//    url = URL(string: gifLocation)
//  }


//var url: URL!
//    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }

