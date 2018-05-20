//
//  NofiticationCell.swift
//  Spottr
//
//  Created by Yash on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class NofiticationCell: UITableViewCell
{

    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblTime : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
