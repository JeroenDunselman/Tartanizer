public class ZPattern {
//  XXX000
//  XX000X
//  X000XX
//  000XXX
//  00XXX0
//  0XXX00
//  public typealias Coordinate = (x: Int, y: Int)
  var len:Int = 3
  var zArr:[[Bool]]
  public init (length: Int) {zArr = [[]]; zArr = getRowCol(withPatternLength: length); len = length}
  
  func getRow(len: Int) -> [Bool] {
    //[f, f, f], XXX
    var array:[Bool] = Array(repeating:true, count:len)
    //[f, f, f, t, t, t], XXX000
    array +=  Array(repeating:false, count:len)
    return array
    
  }
  
  func getRowCol(withPatternLength: Int) -> [[Bool]] {
    //init
    var y:([[Bool]]) = [[true]]; y = []
    //row
    var x:([Bool]) = getRow(len: withPatternLength);
    //remove first rowelement and append, add row to 2D result
    for _ in 0..<x.count {
      var tmp:[Bool]
      tmp = [x.removeLast()]
      tmp += x
      x = tmp
      y += [x]
    }
    return y}

  public func getZBoolForPos(x: Int, y: Int) -> Bool {
    return zArr[x % zArr[0].count][y % zArr[0].count]
  }
}
