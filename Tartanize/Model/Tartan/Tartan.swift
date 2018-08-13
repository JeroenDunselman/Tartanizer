import UIKit

class Tartan: NSObject {
    
    var zPattern: ZPattern = ZPattern(length:3)
    var layOut: [Int] = []
    var sizes: [Int] = []
    public var sumSizes: Int = 0
    
    var colors: [Int] = []
    public var colorSet:Set<Int> = [] //[x, y, x, z], MacKinnon.x.x.x
    public var colorSetCompact: (layOut: [Int], sortString: String) = ([], "")//[0, 1, 0, 2], MacKinnon.x.x.x
    
    init(colors: [Int], sizes: [Int]) {
        super.init()
        
        self.colors = colors
        self.createColorPattern()
        
        self.sizes = sizes
        self.sumSizes = self.sizes.map { $0 }.reduce(0, +)
    }
    
    convenience init(sizes: [Int]){
        var colors: [Int] = []
        
        //colors from palet enumeration with random offset
        let offSet = Palet.shared.clrs.count.asMaxRandom()
        _ = (0..<sizes.count).map({colors.append($0 + offSet)})
        
        self.init(colors: colors, sizes: sizes)
    }
    
    convenience init(randomSizesFor colors: [Int]) {
        let theColors = colors
        let sizes: [Int] = theColors.reduce([]) {(ar, el) in ar + [9.randomFib()]}
        self.init(colors: theColors, sizes: sizes)
    }
    
    var sizesContrast = 4//( x - y > 0 ) : () ?? 5
    func randomContrastFib() -> Int {
        return sizesContrast.randomFib()
    }
    
}

extension Tartan {
    
    func createStructure() -> [Int] {
        
        var definition: [Int] = []
        //get colorstructure
        for i in 0..<self.sizes.count {
            definition += Array(repeatElement(self.colors[i], count: (self.sizes[i])))
        }
        
        //mirror colorstructure
        let reversedArray = definition.reversed()
        let arrImgDef = definition + reversedArray
        
        return arrImgDef
    }
    
}

extension Tartan {
    
    func createColorPattern() {
        
        colorSet = colors.valuedAsSet
        let colorSetPattern = colors
            .reduce([]) {(ar, el) in ar + (!ar.contains(el) ? [el] : [] )}
        
        let layOut = colors.reduce([]) {(ar, el) in ar + [colorSetPattern.index(of: el)!]}
        
        colorSetCompact = (layOut: colors.reduce([]) {(ar, el) in ar + [colorSetPattern.index(of: el)!]},
                           sortString: layOut.reduce("") { ar, el in "\(ar)\(el)"})
    }
}


