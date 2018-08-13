//
//  EditZonesTableViewController.swift
//  kleurkiezert
//
//  Created by Jeroen Dunselman on 23/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import UIKit


class ColorPickerTableViewController: UIViewController {
    public var assets: ColorPickerViewModel?
    let palet = Palet.shared
    var numberOfRows = Palet.shared.clrs.count
    
    @IBOutlet var paletView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    public var image: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    public var assetsVC: ColorPickedAssetsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var timeOutTimer: Timer?
    func reInitCurrentPhrase() {
        
        let timeOut: Double = 1
        timeOutTimer = Timer.scheduledTimer(timeInterval: timeOut, target:self, selector: #selector(reenableRefresh), userInfo: nil, repeats: true)
        
        print("reInitCurrentPhrase")
        self.assets?.createdPhrasesSubject.onNext([]) //self.currentPhrase)
        self.assets?.currentPhrase = []
        self.assets?.colorSet = []
        //    Update view.
        imageView.image = nil
        //        service?.refresh()
        //        tableView.reloadData()
        //
        //        activityIndicatorBottom.isHidden = true
        //        activityIndicatorTop.isHidden = true
    }
    
    @objc func reenableRefresh() {
        timeOutTimer?.invalidate()
        timeOutTimer = nil
        
        //        activityIndicatorBottom.isHidden = false
        //        activityIndicatorTop.isHidden = false
    }
}



extension ColorPickerTableViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows //palet.clrs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.assets?.selectedColorIndexesSubject.onNext(indexPath.row) 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaletCell", for: indexPath)
        
        cell.contentView.backgroundColor = palet.clrs[indexPath.row]
        
        return cell //as TVCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   (self.tableView.frame.size.height / CGFloat(palet.clrs.count)) * 2
    }
}

extension ColorPickerTableViewController: UIScrollViewDelegate {
    //    View fresh batch.
    
    //    Trigger refresh from pull.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //    Prevent repeat refresh for same swipe.
        if !(timeOutTimer == nil) {return}
        
        let pullDistance: CGFloat = 100
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        let triggeredForBottomScroll:Bool = distanceFromBottom < height - pullDistance
        let triggeredForTopScroll:Bool =  scrollView.contentOffset.y < -(pullDistance)
        
        if (triggeredForBottomScroll || triggeredForTopScroll) {
            reInitCurrentPhrase()
        }
    }
    
}

//        assetsVC = AssetsTableViewController()
//        self.addChildViewController(paletVC)
//        paletView.addSubview(paletVC.view)
//        paletVC.view.frame = paletView.bounds
//        paletVC.tableView.reloadData()
//        paletVC.didMove(toParentViewController: self)
