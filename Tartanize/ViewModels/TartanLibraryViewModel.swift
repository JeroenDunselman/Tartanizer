

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
        if let titles = (service.imageService?.assetService.contentTitles()) {
            self.rowTitles = titles
        }
    }
    
    public func filterForInserted(color: Int) {
        service.colorFilter.insert(color: color)
        
        var availableTitles: [String] = service.assetTitlesForColorFilter()
            //filter any custom assets
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
        if availableTitles.count > 0 {
            rowTitles = availableTitles
            //            print("TartanLibraryViewModel filterForInserted \(rowTitles.count)")
            resetClientData()
        } else {
            _ = (0..<2).map({_ in _ = service.imageService?.contentFor(keyTitle: "", imageView: nil)})
            availableTitles = service.assetTitlesForColorFilter()
            if availableTitles.count > 0 {
                rowTitles = availableTitles
                resetClientData()
            }
        }
    }
    
    public func filterFor(colorSet: Set<Int>) {
        service.colorFilter.colorSet = colorSet
        service.colorFilter.filterTitlesForColorSubset()
        let availableTitles: [String] = service.assetTitlesForColorFilter()
            //filter any custom assets
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
        if availableTitles.count > 0 {
            rowTitles = availableTitles
            //            print("TartanLibraryViewModel filterForInserted \(rowTitles.count)")
            resetClientData()
        }
    }
    
    public func refreshContent() {
        //start imaging
        _ = (0..<2).map({_ in _ = service.imageService?.contentFor(keyTitle: "", imageView: nil)})

        //
        service.colorFilter.resetFilter()
        
        rowTitles = (service.imageService?.assetService.contentTitles())!
            .filter({assetTitle in libraryTitles.contains(assetTitle)})
//        print("TartanLibraryViewModel refreshContent \(rowTitles.count)")
        
        resetClientData()
    }
    
    func resetClientData() {
        self.client?.scrollingLocked = true
        self.client?.tableView.reloadData()
        print("reloadData()")
    }
    
    // MARK: Subscriptions
    public func subscribeToSelectedColorIndexes(colorPickerModel: ColorPickerViewModel) {
        
        colorPickerModel.createdAsset.asObservable()
            .subscribe(onNext: { [weak self] layOut in
                
                self?.filterFor(colorSet: (layOut.tartan?.colorSet
                    .filter({$0 != Palet.shared.indexOfColor(color: UIColor.clear)!}))!)
                }, onDisposed: { print("completed selection")})
            .disposed(by: bag)
    }
 
}
