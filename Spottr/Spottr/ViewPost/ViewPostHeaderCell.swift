//
//  ViewPostHeaderCell.swift
//  Spottr
//
//  Created by Yash on 27/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ViewPostHeaderCell: UITableViewCell {

    @IBOutlet weak var imgPost : UIImageView!
    @IBOutlet weak var lblViewCount : UILabel!
    @IBOutlet weak var lblCommentCount : UILabel!
    @IBOutlet weak var lblPostDescription : UILabel!
    @IBOutlet weak var btnPlayVideoIcon : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
