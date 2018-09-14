//
//  UserlistCell.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 10.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var nickNameLabel : UILabel!
    @IBOutlet weak var numberLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ info : UserInfo, at number : Int){

        nameLabel.text = info.firstName + " " + info.lastName
        nickNameLabel.text = info.nickName
        numberLabel.text = String(number)
    }

}
