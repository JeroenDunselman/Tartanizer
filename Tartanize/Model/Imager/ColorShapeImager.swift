//
//  ImageBuilder.swift

//  Created by Jeroen Dunselman on 03/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public extension UIImage {
    
    internal convenience init?(
        
        size: CGSize = CGSize(width: 1, height: 1), dictShapes: [Int:[Coordinate]] = [:]) {
        
        let palet = Palet.shared
        
        let imgRect = CGRect(origin: .zero, size: size)
        let cellSize:CGFloat = 1
        let rSize = CGSize(width: cellSize, height: cellSize)
        UIGraphicsBeginImageContextWithOptions(imgRect.size, false, 0.0)
        
        for colorShape in dictShapes {

            palet.clrs[colorShape.key].setFill()

            for cell in colorShape.value{
                var pos = CGPoint(x:cell.x, y:cell.y)
                var rect = CGRect(origin: pos, size: rSize)
                
                UIRectFill(rect)
                
                let newX:Int = (cell.x + Int(size.width)/2)
                pos = CGPoint(x:newX, y:cell.y)
                rect = CGRect(origin: pos, size: rSize)
                
                UIRectFill(rect)
                
                let newY:Int = (cell.y + Int(size.width)/2)
                pos = CGPoint(x:cell.x, y:newY)
                rect = CGRect(origin: pos, size: rSize)
                
                UIRectFill(rect)
                
                pos = CGPoint(x:newX, y:newY)
                rect = CGRect(origin: pos, size: rSize)
                
                UIRectFill(rect)
                
            }
            
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}




