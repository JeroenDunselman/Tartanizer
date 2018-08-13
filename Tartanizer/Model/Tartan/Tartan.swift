import UIKit


extension Tartan {
    
    func createColorPattern() {

        colorSet = colors.valuedAsSet
        let colorSetPattern = colors
            .reduce([]) {(ar, el) in ar + (!ar.contains(el) ? [el] : [] )}
        
                   let layOut = colors.reduce([]) {(ar, el) in ar + [colorSetPattern.index(of: el)!]}
//        self.colorLayOut.sortString = layOut.reduce("") { ar, el in ar + String("\(el)")}
         colorSetCompact = (layOut: colors.reduce([]) {(ar, el) in ar + [colorSetPattern.index(of: el)!]},
                        sortString: layOut.reduce("") { ar, el in "\(ar)\(el)"})
    }
}

class Tartan: NSObject {
    
    var zPattern: ZPattern = ZPattern(length:3)
    var layOut: [Int] = []
    var sizes: [Int] = []
    public var sumSizes: Int = 0
    
    var colors: [Int] = []
    public var colorSet:Set<Int> = [] //[x, y, x, z], MacKinnon.x.x.x
    public var colorSetCompact: (layOut: [Int], sortString: String) = ([], "")//[0, 1, 0, 2], MacKinnon.x.x.x
    
    func initLayOut() {
        layOut = self.createStructure()
    }

    init(colors: [Int], sizes: [Int]) {
        super.init()
        
        self.colors = colors
        self.createColorPattern()
        
        self.sizes = sizes
        self.sumSizes = self.sizes.map { $0 }.reduce(0, +)

    }
    
    convenience init(sizes: [Int]){ //        var colors: [Int] = []
        var colors: [Int] = []
        //colors from enumeration with random palet offset
        _ = (0..<sizes.count).map({colors.append($0 + Palet.shared.clrs.count.asMaxRandom())})
        
        self.init(colors: colors, sizes: sizes)
    }
    
    convenience init(randomSizesFor colors: [Int]) {
        let theColors = colors
        let sizes: [Int] = theColors.reduce([]) {(ar, el) in ar + [9.randomFib()]}
        self.init(colors: theColors, sizes: sizes)
    }
    
    convenience init(withRandomSizesFor board: LayOut) {
        print("withRandomSizesFor \(board.colorSet)")

        let colors = board.colorZones
        let sizes: [Int] = colors.reduce([]) {(ar, el) in ar + [board.sizesContrast.randomFib()]}
        self.init(colors: colors, sizes: sizes)

    }
    
    //    untested
    convenience init(withRandomColorsFor sizes: [Int]){
        let sizes = sizes
        let colors = sizes.reduce([]) {(ar, el) in ar + [
            Palet.shared.indexOfColor(color: Palet.shared.clrs[Palet.shared.clrs.count.asMaxRandom()] )
            ]} as! [Int]
        
        self.init(colors: colors, sizes: sizes)
    }
    
    convenience override init() {
        let sizes = [5, 21, 8, 13]
        let colors = [0, 1, 2, 1]
        
        self.init(colors: colors, sizes: sizes)
    }
    
    var sizesContrast = 4//( x - y > 0 ) : () ?? 5
    func randomContrastFib() -> Int {
        return sizesContrast.randomFib()
    }
    
}



extension Tartan {
    
    func createStructure() -> [Int] {
        //to undo: colorindex side effect//self.tartan?.scramble()
        //        print("createStructure\n sizes: \n\(tartan?.sizes)\ncolors:\n\(tartan?.colors)")
        
        var definition: [Int] = []
        //get colorstructure
        for i in 0..<self.sizes.count {
            definition += Array(repeatElement(self.colors[i], count: (self.sizes[i])))
        }
        //        self.size = (tartan?.sizes.map { $0 }.reduce(0, +))!
        //        self.size = (tartan?.definitionSize)!
        
        //mirror colorstructure
        let reversedArray = definition.reversed()
        let arrImgDef = definition + reversedArray
        
        //factor necessary for integral zPat, preventing interference
        //determine factor necessary for zPat
        //        while (fact*arrImgDef.count % zPattern.len != 0) {
        //            fact += 1
        //        }
        
        
        
        return arrImgDef
        
    }
}
