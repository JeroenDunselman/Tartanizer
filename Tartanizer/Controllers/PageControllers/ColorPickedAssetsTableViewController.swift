
//  AssetsViewControllerTableViewController.swift
//  kleurkiezert
//
//  Created by Jeroen Dunselman on 16/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import UIKit
import RxSwift

class ColorPickedAssetsTableViewController: UITableViewController {
    public var assets: ColorPickedAssetsViewModel?
    
    private let selectedAssetSubject = PublishSubject<LayOut>()
    var selectedAssets: Observable<LayOut> {
        return selectedAssetSubject.asObservable()
    }
    
  
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red

        print("didLoad AssetsTableViewController")
        
        if assets?.boards.count == 0 {

//            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return UITableViewAutomaticDimension
        return self.view.frame.size.width
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets!.boards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TVCell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as! TVCell
//        print("\(indexPath.row): \(assets?.boards.reversed()[indexPath.row].entry?.title ?? ""), \(assets?.boards.reversed()[indexPath.row].entry?.definition?.tartan.colorLayOut.sortString ?? "")")
        if let img = assets?.boards.reversed()[indexPath.row].images["initial"] { // . []. //(assets?.reversed()[indexPath.row])!
//            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
            cell.cellImage!.image = img as? UIImage
        }
        return cell as TVCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo test
        if !(timeOutTimer == nil) {
            print("timeOutTimer")
            return
            
        }
        selectedAssetSubject.onNext((assets?.boards.reversed()[indexPath.row])!)
    }
    
    
    var timeOutTimer: Timer?
    func reInitCurrentPhrase() {
        
        let timeOut: Double = 1
        timeOutTimer = Timer.scheduledTimer(timeInterval: timeOut, target:self, selector: #selector(reenableRefresh), userInfo: nil, repeats: true)
        
//        print("reInitCurrentPhrase")
//        self.currentPhrase = []
//        //    Update view.
//        self.imageView.image = nil
//        //        service?.refresh()
//        //        tableView.reloadData()
//        //
//        //        activityIndicatorBottom.isHidden = true
//        //        activityIndicatorTop.isHidden = true
    }
    
    @objc func reenableRefresh() {
        timeOutTimer?.invalidate()
        timeOutTimer = nil
        
        //        activityIndicatorBottom.isHidden = false
        //        activityIndicatorTop.isHidden = false
    }

}

//
//        let anagramsVC: AnagramsTableViewController = storyboard!.instantiateViewController(
//            withIdentifier: "AnagramsTVC") as! AnagramsTableViewController
//
//private let sizesContrast: Int = 8
//        anagramsVC.client = self
//        anagramsVC.seed = boards.reversed()[indexPath.row]
//        anagramsVC.seed?.sizesContrast = self.sizesContrast
//        title = String("contrast: \(self.sizesContrast), sizes: \(anagramsVC.seed?.colorZones.count ?? 0), colors: \(anagramsVC.seed?.colorSet.count ?? 0)")
//
//        navigationController!.pushViewController(anagramsVC, animated:
//            true)


// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
// self.navigationItem.rightBarButtonItem = self.editButtonItem

// Uncomment the following line to preserve selection between presentations
// self.clearsSelectionOnViewWillAppear = false
