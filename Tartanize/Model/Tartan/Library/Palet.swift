import Foundation
import UIKit
typealias MapInfo = (Int, UIColor)

class Palet {
    
    // MARK: - Properties
    
    static let shared = Palet()
    
    let colorMap: [String : (Int, UIColor)]
    let clrs: [UIColor]
    
    // Initialization
    
    private init() {
        var pos: [String : (Int, UIColor)] = [:]
        
        pos["Y"] = (0, UIColor.yellow)
        pos["A"] = (1, UIColor.magenta)
        pos["DB"] = (2, UIColor.orange)
        pos["K"] = (3, UIColor.black)
        pos["B"] = (4, UIColor.blue)
        pos["R"] = (5, UIColor.red)
        pos["G"] = (6, UIColor.green)
        pos["N"] = (7, UIColor.gray)
        pos["P"] = (8, UIColor.purple)
        pos["T"] = (9, UIColor.brown)
        pos["W"] = (10, UIColor.white)
        pos["C"] = (11, UIColor.lightGray)
        pos["S"] = (12, UIColor.cyan)
        pos["DR"] = (13, UIColor.yellow)
        pos["LB"] = (14, UIColor.magenta)
        pos["DBG"] = (15, UIColor.orange)
        pos["RB"] = (16, UIColor.black)
        pos["DG"] = (17, UIColor.blue)
        pos["LR"] = (18, UIColor.red)
        pos["LN"] = (19, UIColor.green)
        pos["DN"] = (20, UIColor.gray)
        pos["XL"] = (21, UIColor.purple)
        pos["CLR"] = (22, UIColor.clear)
        
        colorMap = pos
        clrs = colorMap.map {$0.1}.sorted(by: {$0.0 < $1.0})
            .map {$0.1 }
    }

    public func indexOfColor(color: UIColor) -> Int? {
        return colorMap.first(where: {$0.value.1 == color})?.value.0
    }
    
}

public extension UIImage {
    
    public convenience init?(zones: [(Int, Int)]) {
        let p = Palet.shared
        let rect = CGRect(origin: .zero, size: CGSize(width: 10, height: 10))
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        _ = zones.map( { _ in
            p.clrs[zones[0].1].setFill()
            UIRectFill(rect)
        })
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
