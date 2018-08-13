//
//  TartanLibraryTableViewController.swift
//
//  Created by Jeroen Dunselman on 25/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import UIKit

class TartanLibraryTableViewController: UITableViewController {
    public var assets = TartanLibraryViewModel()

    let initialNumberOfRows = 4
    var scrollingLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(TVCell.self, forCellReuseIdentifier: "AssetCell")
       
        assets.client = self
        assets.initKeyTitlesFor(rows: initialNumberOfRows)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.rowTitles.count //numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "TartanCell")
                let cell: TVCell = tableView.dequeueReusableCell(withIdentifier: "TartanCell", for: indexPath) as! TVCell
//        cell.cellImage!.image = nil
        let defaultImage = UIImage(color: UIColor.green, size: CGSize(width: 200, height: 200))!
        let blueImage = UIImage(color: UIColor.blue, size: CGSize(width: 200, height: 200))!
        var resultImage = defaultImage
    
        let row = indexPath.row
        if let resultAsset = assets.service.imageService?.contentFor(keyTitle: assets.rowTitles[row], imageView: nil) {
//            print("\(row): \(assets.rowTitles[row]), \(resultAsset.entry.definition?.tartan.colorSet ?? [])")
            if resultAsset.request.finished {
                resultImage = resultAsset.request.layOut.images["initial"] as! UIImage
                cell.activityIndicatorView.isHidden = true
                cell.activityIndicatorView.stopAnimating()
            } else {
//                print("unfinished: \(assets.rowTitles[row])")
                let asset = assets.service.imageService?.contentFor(
                    keyTitle: assets.rowTitles[row],
                    imageView: cell.cellImage!)
//                asset?.request.client = self
//                asset?.request.path = indexPath
                asset?.request.activityView = cell.activityIndicatorView
                cell.activityIndicatorView.isHidden = false
                cell.activityIndicatorView.startAnimating()
                resultImage = blueImage
            }
        }
//        cell.imageView?.image = resultImage
                    cell.cellImage!.image = resultImage //as? UIImage
//        return cell
        return cell as TVCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.size.width // 1.61803
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

