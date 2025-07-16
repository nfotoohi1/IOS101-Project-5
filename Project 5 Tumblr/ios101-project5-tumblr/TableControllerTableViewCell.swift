//
//  TableControllerTableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Nora Fotoohi on 7/15/25.
//

import UIKit

class TableCellController: UITableViewCell {

    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
