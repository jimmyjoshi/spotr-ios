//
//  FriendsTableViewCell.swift
//  Spottr
//
//  Created by Yash on 26/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell
{
    @IBOutlet weak var imgUserProfile : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var btnRemoveFriend : UIButton!

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
