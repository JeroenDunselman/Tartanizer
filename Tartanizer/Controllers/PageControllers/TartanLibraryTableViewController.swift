//
//  TartanLibraryTableViewController.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 25/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//
//    private let selectedLibraryImageSubject = PublishSubject<LayOut>()
//    var selectedLibraryImages: Observable<LayOut> {
//        return selectedLibraryImageSubject.asObservable()
//    }
//

import UIKit

class TartanLibraryTableViewController: UITableViewController {
    public var assets = TartanLibraryViewModel()

//    var numberOfRows:Int = 0 {didSet { print("numberOfRows is nu \(numberOfRows).")}}
    let initialNumberOfRows = 4
    let maxNumberOfRows = 60
    var scrollingLocked = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        tableView.register(TVCell.self, forCellReuseIdentifier: "TartanCell")
       
        assets.client = self
        assets.initKeyTitlesFor(rows: initialNumberOfRows)
//        numberOfRows = initialNumberOfRows
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("assets.rowTitles.count: \(assets.rowTitles.count)") //numberOfRows}
        return assets.rowTitles.count //numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "TartanCell")
        
        let defaultImage = UIImage(color: UIColor.green, size: CGSize(width: 200, height: 200))!
        let blueImage = UIImage(color: UIColor.blue, size: CGSize(width: 200, height: 200))!
        var resultImage = defaultImage
    
        let row = indexPath.row
        if let resultAsset = assets.service.imageService?.contentFor(keyTitle: assets.rowTitles[row], imageView: nil) {
            print("\(row): \(assets.rowTitles[row]), \(resultAsset.entry.definition?.tartan.colorSet ?? [])")
            if resultAsset.request.finished {
                resultImage = resultAsset.request.layOut.images["initial"] as! UIImage
                
            } else {
//                print("unfinished: \(assets.rowTitles[row])")
                _ = assets.service.imageService?.contentFor(keyTitle: assets.rowTitles[row], imageView: cell.imageView!)
                
                resultImage = blueImage
            }
        }
        
        cell.imageView?.image = resultImage
        return cell
    }//as TartanCell
    //let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TartanCell", for: indexPath) as! UITableViewCell
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.size.width // 1.61803
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if let availableRequest: LayOutRequest = service?.findInfoFor(row: indexPath.row) {
        //            self.selectedLibraryImageSubject.onNext(availableRequest.checkerBoard)
        //        }
        //
        //        let pickedVC = storyboard!.instantiateViewController(
        //            withIdentifier: "PickedAssetVC") as! PickedAssetViewController
        //        if let availableRequest = service?.findInfoFor(row: indexPath.row) {
        //
        //            pickedVC.checkerBoard = availableRequest.checkerBoard
        //        }
        //
        //        title = String("contrast: \(self.sizesContrast), sizes: \(pickedVC.checkerBoard?.colorZones.count ?? 0), colors: \(pickedVC.checkerBoard?.colorSet.count ?? 0)")
        //        navigationController!.pushViewController(pickedVC, animated:
        //            true)
        //        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // MARK: - timeOut Refresh
    
    public var timeOutTimer: Timer?
    func scrollAction() {

        let rows = tableView.numberOfRows(inSection: 0)
        let timeOut: Double = 1
        timeOutTimer = Timer.scheduledTimer(timeInterval: timeOut, target:self, selector: #selector(reenableScrollAction), userInfo: nil, repeats: true)
        
        assets.refreshContent()
        print("scroll \(rows) refreshed: \(tableView.numberOfRows(inSection: 0))")
    }
    
    @objc func reenableScrollAction() {
        timeOutTimer?.invalidate()
        timeOutTimer = nil
        
        //        activityIndicatorBottom.isHidden = false
        //        activityIndicatorTop.isHidden = false
    }
    
    // MARK: - scrolling
    func scrollToBottom() { //niu
        DispatchQueue.main.async {
            
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollingLocked = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scrollingLocked = true
    }
}

extension TartanLibraryTableViewController {
    //    View fresh batch.
    
    //    Trigger refresh from pull.
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //    Prevent repeat refresh for same swipe.
        if !(timeOutTimer == nil) {return}
        
        let pullDistance: CGFloat = 100
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        let triggeredForBottomScroll:Bool = distanceFromBottom < height - pullDistance
        let triggeredForTopScroll:Bool =  scrollView.contentOffset.y < -(pullDistance)
        
        if (triggeredForBottomScroll || triggeredForTopScroll) {
            
            if !scrollingLocked {scrollAction()}
        }
    }
    
}

