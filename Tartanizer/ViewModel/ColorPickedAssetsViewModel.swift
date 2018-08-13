//
//  ColorPickedAssetsViewModel.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import RxSwift

class ColorPickedAssetsViewModel: NSObject {
    let bag = DisposeBag()
    
    let client: ColorPickedAssetsTableViewController?
    let imageService = FilteredTartanImageService() //TartanImageService() //.shared
    
    var boards: [LayOut] = [] //
    var entries: [Entry] = []                 //                self?.entries.append(Entry(title: ("\(addedBoard.entry?.title)\(addedBoard.tartan?.colorLayOut.sortString ?? "htsflts")"), definition: addedBoard.entry?.definition))
    
    var setFromLibrary: Set<String> = []
    
    init(client: ColorPickedAssetsTableViewController) {
        self.client = client
        
        //        subscribeToSelectedColorIndexes(service: client.)
    }
    
    func insert(layOut: LayOut) {
        if !(setFromLibrary.contains((layOut.entry?.title)!)) {
            setFromLibrary.insert((layOut.entry?.title)!)
            boards.append(layOut)
        }
    }
    
    public func subscribeToSelectedColorIndexes(service: ColorPickerViewModel) {
        service.createdAsset.asObservable()
            .subscribe(onNext: { [weak self] addedBoard in
                
                self?.boards.append(addedBoard)
                self?.imageService.colorFilter.colorSet = (addedBoard.tartan?.colorSet)!
                self?.imageService.colorFilter.filterTitlesForColorSubset()
                
                if let availableForColor = self?.imageService.colorVariationsFromLibrary(of: addedBoard, maxCount: 2) {
                    _ = availableForColor.map({
                        self?.insert(layOut: $0)
//                        if !(self?.setFromLibrary.contains(($0.entry?.title)!))! {
//                            self?.setFromLibrary.insert(($0.entry?.title)!)
//                            self?.boards.append($0)
//                        }
                    })
                }
                
                if let availableForPattern = self?.imageService.patternVariationsFromLibrary(of: addedBoard, maxCount: 2 ) {
                    _ = availableForPattern.map({ self?.insert(layOut: $0)})
//                        if !(self?.setFromLibrary.contains(($0.entry?.title)!))! {
//                            self?.setFromLibrary.insert(($0.entry?.title)!)
//                            self?.boards.append($0)
//                        }
//                    })
                }
                
                self?.client?.tableView.reloadData()
                //start creating anagrams if checkerboard was last before reInitPhrase
                //                self?.updateUI(lastChoice: addedZone)
                //                self?.navigationController!.popViewController(animated: true)
                
                }, onDisposed: { print("completed photo selection")
            } )
            .disposed(by: bag)
    }
    
}
