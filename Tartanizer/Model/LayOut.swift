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
//    var random: Tartan?
    var tartan: Tartan?

    //    2d
    var cells: [[Int]] = []
    var colorShapes: [Int:[Coordinate]] = [:]
    
    //    1d
    var colorZones: [Int]
    
    var colorSet: Set<Int> {
        return colorZones.valuedAsSet //?already in tartan
    }

    var zFactor = 1
    var sizesContrast: Int = 5
//    func sizesContrast(defaultSize: Int) -> Int {
//        let x = 15
//        print("sizesContrast: \(x - currentPhrase.count)")
//        return 5 // max(5, x - currentPhrase.count)
//    }
    init(withRandomSizesForAnagram colorZones: [Int], sizesContrastDefault: Int) {

        self.colorZones = colorZones
        sizesContrast = sizesContrastDefault
        tartan = Tartan(withRandomSizesFor: self)
    }
    
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

        tartan?.layOut = (tartan?.createStructure())!
        
        //todo prevent unequally defined imgs,  if zFactor == 1 {img.collage(3*3)}
        //        todo ffact = zPat? zPat/2
        if (tartan?.layOut.count)! % (tartan?.zPattern.len)! != 0 { self.zFactor = 3 }
        
        //turn colorstructure 2d
        createCellsFromStructure(definition: (tartan?.layOut)!)
        
        //group cells by color into clrShapes
        createShapesfromCells(colorSet: (tartan?.colorSet)! ) //trtn!.colorSetNumeric!)
        
        images["initial"] = createImage() //images["noir"] = (images["initial"] as! UIImage).noir
        
        return images["initial"] as! UIImage
    }
    
    
    
    //** editZonesVC
    func createImage() -> UIImage {
        //turn colorstructure 2d
        createCellsFromStructure(definition: (self.tartan?.layOut)!)
        
        //group cells by color into clrShapes
        createShapesfromCells(colorSet: (tartan?.colorSet)! ) //trtn!.colorSetNumeric!)
        
        //set imgsize to repeats of defsize
        let repeatSize = 4 * zFactor
        let definitionSize = self.tartan?.sumSizes// .definitionSize //self.size
        let imageSize = repeatSize*definitionSize!
//        print("create: \(definitionSize! * zFactor)")
        
        //create 2 images for price of one
        //    var imageTartan = UIImage()
        //    var imageTartanRandomPalet = UIImage()
        
        if let imageTartan:UIImage = UIImage(
            size: CGSize(width: imageSize, height: imageSize),
//            palet: nil,
            randomPalet: false,
            dictShapes: colorShapes
            ) { return imageTartan }
    
        return UIImage(color: UIColor.darkGray)!
    }
    

    public func zoneIndexEdit() -> UIImage {
        
        //        self.tartan?.createStructure() //from zones
        //turn colorstructure 2d
        createCellsFromStructure(definition: (tartan?.layOut)!)
        //group cells by color into clrShapes
        createShapesfromCells(colorSet: (tartan?.colorSet)! ) //trtn!.colorSetNumeric!)
        
        let edit = createImage()
        images["edited"] = [edit] //from shapes
        //        images["noir"] = (images["initial"] as! UIImage).noir
        
        return edit  //images["initial"] as! UIImage
    }
    
    public func selected() {
        print("LayOut.selected()! How can I help?")
        //        tartan = Tartan(withRandomColorsFor: (self.tartan?.sizes)!)
    }
    
    init(entryy: Entryy) {
        self.tartan = entryy.1.tartan
        self.colorZones = (self.tartan?.colors)!
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

//create new set of defs by changing colors while retaining sizes
//    public func randomWithColorvariations() -> [Tartan] {
//        var base: [Tartan]  = [tartanRandom()!]
//        let palet = Palet.shared
//
//        //48=?
//        for i in 0..<48 {
//
//            var clrs:[Int] = base[i].colors.map{ $0 + (palet.colorMap.count).asMaxRandom()}
//
//            //check colors
//            for j in 0..<clrs.count {
//                //limit int clr to size of colorMap
//                while  clrs[j] >= palet.colorMap.count { clrs[j] = clrs[j] - palet.colorMap.count }
//            }
//
//            let t = Tartan(colors: clrs, sizes: (base[i].sizes))
//            base.append(t)
//
//        }
//        return base
//    }
