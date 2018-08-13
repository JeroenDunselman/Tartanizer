import UIKit

class TartanCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView! //weak?
//
    @IBOutlet weak var eenTextView: UITextView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        //         self.imageView?.image = asset
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        cellImage?.image = nil
//    }
    
    //  func flash() {
    //    cellImage.alpha = 0
    //    setNeedsDisplay()
    //    UIView.animate(withDuration: 0.5, animations: { [weak self] in
    //      self?.cellImage.alpha = 1
    //    })
    //
    //  }
}
