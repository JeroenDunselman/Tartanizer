//
//  ColorPickerViewModel.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 08/08/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import RxSwift

class ColorPickerViewModel {
    let bag = DisposeBag()
    var client = ColorPickerTableViewController()
    
    let service = FilteredTartanImageService()
    let selectedColorIndexesSubject = PublishSubject<Int>()
    var  selectedColorIndexes: Observable<Int> {
        return selectedColorIndexesSubject.asObservable().share()
    }
    
    private let createdAssetsSubject = PublishSubject<LayOut>()
    var  createdAsset: Observable<LayOut> {
        return createdAssetsSubject.asObservable()
    }
    
    let createdPhrasesSubject = PublishSubject<[[Int]]>()
    var  createdPhrase: Observable<[[Int]]> {
        return createdPhrasesSubject.asObservable()
    }
    
    var currentPhrase: [Int] = []
    var colorSet: Set<Int> = []
    
    init(client: ColorPickerTableViewController) {
        self.client = client
    }
    
    func layOutFrom(phrase: [Int]) -> LayOut {
        
        if phrase.count == 1 {
            let tartan: Tartan = Tartan(randomSizesFor: [phrase[0], Palet.shared.indexOfColor(color: UIColor.clear)!])
            return LayOut.init(tartan: tartan)
        }
        
        //get sizes from library definitions similar to current phrase
        let similarEntries: [Entry?] = (self.service.library
            .filter({$0.definition?.tartan.colors.count == phrase.count}))
        
        if similarEntries.count > 0, let similar: Entry = similarEntries[similarEntries.count.asMaxRandom()] {
            
            let pattern: Tartan = Tartan(colors: phrase, sizes: (similar.definition?.tartan.sizes)!)
            pattern.createColorPattern()
            
            let verySimilarEntries: [Entry?] = similarEntries
                .filter({$0!.definition?.tartan.colorSetCompact.sortString == pattern.colorSetCompact.sortString})
            
            if verySimilarEntries.count > 0, let verySimilar = verySimilarEntries[verySimilarEntries.count.asMaxRandom()] {
                
                let layOut = LayOut.init(tartan: Tartan(colors: (phrase), sizes: (verySimilar.definition?.tartan.sizes)!))
                print("returning verySimilar \(verySimilar.title)")
                return layOut
            }
            
            let layOut = LayOut.init(tartan: pattern)
            print("returning similar \(similar.title)")
            return layOut
        }
        
        let layOut = LayOut(tartan: Tartan(randomSizesFor: phrase))
        
        return layOut
        
    }
    
    func register(selected row: Int) {
        //register choice
        currentPhrase.append(row)
        colorSet.insert(row)
    }
    
//    func initializeImage() -> LayOut {
//        //init image
//        let layOut = layOutFrom(phrase: currentPhrase)
//        client.imageView.image = layOut.images["initial"] as? UIImage
//
//        return layOut
//    }
    
    public func subscribeToSelectedColorIndexes() {
        
        print("subscribing ToSelectedColorIndexes")
        
        self.selectedColorIndexes.asObservable()
            .subscribe(onNext: { [weak self] rowSelected in
                
                self?.register(selected: rowSelected)
                
                if let layOut = self?.layOutFrom(phrase: (self?.currentPhrase)!) { //self?.initializeImage() {
                    //_ = layOut.startImage()
                    let request = ImageRequest(checkerBoard: layOut)
                    request.imageView = self?.client.imageView
                    request.downloadImage()
//                    self?.client.imageView.image = layOut.images["initial"] as? UIImage
                    self?.createdAssetsSubject.onNext(layOut)
                }
                
                }, onDisposed: { print("completed photo selection")
            })
            .disposed(by: bag)
    }
    
}
