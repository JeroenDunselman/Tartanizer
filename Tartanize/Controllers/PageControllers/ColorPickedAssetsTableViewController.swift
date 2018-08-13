
//  AssetsViewControllerTableViewController.swift
//
//  Created by Jeroen Dunselman on 16/03/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import UIKit
import RxSwift

class ColorPickedAssetsTableViewController: UITableViewController {
    public var assets: ColorPickedAssetsViewModel?

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
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
//        let e = assets?.boards.reversed()[indexPath.row].entry
//        print("\(indexPath.row): \(e!.title ), \(e!.definition?.tartan.colorSetCompact.sortString ?? "")")
        if let image = assets?.boards.reversed()[indexPath.row].images["initial"] {
        
//            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
            cell.cellImage!.image = image as? UIImage
        }
        return cell as TVCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
