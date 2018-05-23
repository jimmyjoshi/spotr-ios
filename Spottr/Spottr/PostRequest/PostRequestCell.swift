//
//  PostRequestCell.swift
//  Spottr
//
//  Created by Kevin on 23/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class PostRequestCell: UITableViewCell {

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var btnReject : UIButton!
    @IBOutlet weak var btnApprove : UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
