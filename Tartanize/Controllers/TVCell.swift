import UIKit

class TVCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView! //weak?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
            cellImage?.image = nil
    }
    
}
