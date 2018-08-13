//
//  Checkerboard.swift

//  Created by Jeroen Dunselman on 03/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reservedvar/

import Foundation
import UIKit


typealias Coordinate = (x: Int, y: Int)

public class LayOut {
    var images: [String:Any] = [:]
    
    var entry: Entry?
    var tartan: Tartan?

    //    2d
    var cells: [[Int]] = []
    var colorShapes: [Int:[Coordinate]] = [:]
    
    //    1d
    var colorZones: [Int]
    
    var colorSet: Set<Int> {
        return colorZones.valuedAsSet //?already in tartan
    }

    var zFactor = 3
    var sizesContrast: Int = 5
    
    init(tartan: Tartan) {
        self.tartan = tartan
        self.colorZones = tartan.colors
    }

    init(entry: Entry) {
        self.tartan = entry.definition?.tartan // .1.tartan
        self.colorZones = (self.tartan?.colors)!
        self.entry = entry
    }
    
    public func startImage() -> UIImage {

        self.tartan?.layOut = (self.tartan?.createStructure())!
        
        //todo prevent unequally defined imgs,  if zFactor == 1 {img.collage(3*3)}
        //        todo ffact = zPat? zPat/2
        if (self.tartan?.layOut.count)! % (self.tartan?.zPattern.length
            )! != 0 { self.zFactor = 3 }
        
        //turn colorstructure 2d
        self.createCellsFromStructure(definition: (self.tartan?.layOut)!)
        
        //group cells by color into clrShapes
        self.createShapesfromCells(colorSet: (self.tartan?.colorSet)! ) //trtn!.colorSetNumeric!)
        
        self.images["initial"] = self.createImage() //images["noir"] = (images["initial"] as! UIImage).noir
        
        return self.images["initial"] as! UIImage
        
    }
    
    func createImage() -> UIImage {
        //turn colorstructure 2d
        createCellsFromStructure(definition: (self.tartan?.layOut)!)
        
        //group cells by color into clrShapes
        createShapesfromCells(colorSet: (tartan?.colorSet)! )
        
        //set imgsize to repeats of defsize
        let repeatSize = 4 * zFactor
        let definitionSize = self.tartan?.sumSizes
        let imageSize = repeatSize*definitionSize!
        
        if let imageTartan:UIImage = UIImage(
            size: CGSize(width: imageSize, height: imageSize),
            dictShapes: colorShapes) { return imageTartan }
    
        return UIImage(color: UIColor.darkGray)!
    }
    
}

extension LayOut {
    func createShapesfromCells(colorSet: Set<Int>) {
        let colors = Array(colorSet)
        //initialize keys
        for (_, element) in colors.enumerated() { self.colorShapes.updateValue([], forKey: element) }
        
        //create shapes by gathering cells for each color
        for i in colors {
            var shape: [Coordinate] = []
            
            for (x, elementX) in self.cells.enumerated() {
                for (y, elementY) in elementX.enumerated()  {
                    
                    guard elementY == i else { continue }
                    let pos: Coordinate = Coordinate(x: x, y: y)
                    shape.append(pos)
                }
            }
            
            self.colorShapes[i] = shape //.updateValue(shape, forKey: i)
        }
    }
    
    func createCellsFromStructure(definition: [Int?]){
        
        //determine color for coord and store
        var color: Int = 0
        for x in 0..<definition.count*zFactor {
            
            var row:[Int] = []
            for y in 0..<definition.count*zFactor {
                let pos:Coordinate = Coordinate(x:x, y:y)
                color = 0
                
                //alternate colorsource orientation using zPat
                if (self.tartan?.zPattern.getZBoolForPos(x: pos.x, y: pos.y))! {
                    //?          if let _ = arr2D[x % arr2D.count] {
                    color = definition[x % definition.count]!
                    //          }
                } else {
                    if let result = definition[y % definition.count] { //??
                        color = result //definition[y % definition.count]!
                    }
                }
                row.append(color)
            }
            self.cells.append(row)
        }
    }
    
}
