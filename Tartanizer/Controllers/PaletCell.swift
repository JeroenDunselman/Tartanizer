//
//  PaletCell.swift
//  pvc holadijee
//
//  Created by Jeroen Dunselman on 28/07/2018.
//  Copyright © 2018 Jeroen Dunselman. All rights reserved.
//

import Foundation
import UIKit
class PaletCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView! //weak?
    
    
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
        cellView?.backgroundColor = UIColor.cyan //image = nil
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
