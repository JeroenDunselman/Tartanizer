

import Foundation
import RxSwift

typealias TartanDefinition = (tartan: Tartan, info: [String:Any])
typealias Entry = (title: String, definition: TartanDefinition?)
typealias Asset = (entry: Entry, request: ImageRequest)

class TartanLibraryViewModel {
    let bag = DisposeBag()
    
    let libraryTitles: [String] = LibraryContents.shared.publicTitles
    let service = FilteredTartanImageService()
    
    public var client: TartanLibraryTableViewController?
    public var rowTitles: [String] = []
    
    public func initKeyTitlesFor(rows: Int) {
        
        _ = (0..<rows).map({_ in _ = service.imageService?.contentFor(keyTitle: "", imageView: nil)})
//        rowTitles = (service.imageService?.assetService.contentTitles())!
        if let titles = (service.imageService?.assetService.contentTitles()) {
            self.rowTitles = titles
        }
    }
    
    public func filterForInserted(color: Int) {
        service.colorFilter.insert(color: color)
        
        let availableTitles: [String] = service.assetTitlesForColorFilter()
            //filter any custom assets
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
        if availableTitles.count > 0 {
            rowTitles = availableTitles //service.assetTitlesForColorFilter() //.titlesInColorSet
            //            print("TartanLibraryViewModel filterForInserted \(rowTitles.count)")
            resetClientData()
        } //else retain available Titles of ultimate colorFilter
    }
    
    public func filterFor(colorSet: Set<Int>) {
        service.colorFilter.colorSet = colorSet //.insert(color: color)
        rowTitles = service.assetTitlesForColorFilter()            //filter any custom assets
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
        print("TartanLibraryViewModel filterForInserted \(rowTitles.count)")
        
        resetClientData()
    }
    
    public func refreshContent() {
        
        service.colorFilter.resetFilter()
        rowTitles = (service.imageService?.assetService.contentTitles())!
        
        //filter any custom assets
        rowTitles = rowTitles
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
        
        
        print("TartanLibraryViewModel refreshContent \(rowTitles.count)")
        
        resetClientData()
    }
    
    func resetClientData() {
        self.client?.scrollingLocked = true
        self.client?.tableView.reloadData()
        print("reloadData()")
    }
    
    // MARK: Subscriptions
    public func subscribeToSelectedColorIndexes(colorPickerModel: ColorPickerViewModel) {
        
        colorPickerModel.createdPhrase.asObservable()
            .subscribe(onNext: { [weak self] phrase in //[Int] //.ignoreElements() onCompleted
                
                //initialize for next phrase
                self?.service.colorFilter.colorSet = []
                
                }, onDisposed: { print("completed selection")})
            .disposed(by: bag)
        
        colorPickerModel.selectedColorIndexes.asObservable()
            .subscribe(onNext: { [weak self] clrIndex in
                
                self?.filterForInserted(color: clrIndex)
            }, onDisposed: { print("completed selection")})
            .disposed(by: bag)
    }
    //    public func subscribeToCreatedLibraryImage(service: ImageService) {
    //
    ////        service.selectedAssets.asObservable()
    ////            .subscribe(onNext: { [weak self] addedBoard in
    ////
    ////                self?.seed = addedBoard
    ////                self?.service = ImageService(client: self!)
    ////                self?.numberOfRows = (self?.service?.colorAnagramsService!.base.count)!
    ////                if let img = self?.seed?.images["initial"] as? UIImage  { self?.defaultImage = img }
    ////                self?.tableView.reloadData()
    ////                }, onDisposed: { print("completed photo selection")
    ////            } )
    ////            .disposed(by: bag)
    //    }
    
    
    
    
}


//    todo move to service

//    private func tartans() -> [Tartan] {
//        return self.library.reduce([], {ar, el in return ar + [el.value.tartan] })
//    }

//    func tartanRandom() -> Tartan? {
//
//        var base = self.library.reduce([], {ar, el in return ar + [el.value.tartan] })
//            .filter({$0.sumSizes < 125 }) //>35
//            .filter({$0.colors.valuedAsSet.count > 5})
//        if base.count > 0 { return base.remove(at: base.count.asMaxRandom())}
//
//        return nil
//    }

//    public func tartansByColor() -> [Tartan] {
//        let x = library.values.sorted{ $0.tartan.colorSortString < $1.tartan.colorSortString }
//        return x.reduce([], {ar, el in return ar + [el.tartan] })
//    }
//
//    public func tartansMultiplied() -> [Tartan] {
////[A, B, C, D]->[AB, BC, CD]
//        var assets:[Tartan] = []
//        let x = library.values.filter({$0.tartan.sumSizes < 75})
//                                .filter({$0.tartan.colorSet.count < 7})
////
//        for i in 0..<x.count - 2 {
//            let t:Tartan = Tartan(colors: x[i].tartan.colors + x[i + 1].tartan.colors,
//                                   sizes: x[i].tartan.sizes + x[i + 1].tartan.sizes)
//            assets.append(t)
//        }
//        return assets
//    }






