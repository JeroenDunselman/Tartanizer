//
//  CatTVCell.swift
//  XMLParsingDemo
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView! //weak?

   
    override func awakeFromNib() {
       
        super.awakeFromNib()
//         self.imageView?.image = asset
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
            cellImage?.image = nil
    }
    
    //  func flash() {
    //    cellImage.alpha = 0
    //    setNeedsDisplay()
    //    UIView.animate(withDuration: 0.5, animations: { [weak self] in
    //      self?.cellImage.alpha = 1
    //    })
    //
    //  }
}
