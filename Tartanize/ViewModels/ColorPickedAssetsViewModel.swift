//
//  ColorPickedAssetsViewModel.swift
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import RxSwift

class ColorPickedAssetsViewModel: NSObject {
    let bag = DisposeBag()
    
    let client: ColorPickedAssetsTableViewController?

    var boards: [LayOut] = [] //
    
    init(client: ColorPickedAssetsTableViewController) {
        self.client = client
    }
    
    public func subscribeToSelectedColorIndexes(service: ColorPickerViewModel) {
        service.createdAsset.asObservable()
            .subscribe(onNext: { [weak self] addedBoard in
                self?.boards.append(addedBoard)
                self?.client?.tableView.reloadData()
                }, onDisposed: { print("completed photo selection")
            } )
            .disposed(by: bag)
    }
    
}
