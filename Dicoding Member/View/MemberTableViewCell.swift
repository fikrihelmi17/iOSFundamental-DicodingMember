//
//  MemberTableViewCell.swift
//  Dicoding Member
//
//  Created by Fikri on 20/07/20.
//  Copyright © 2020 Fikri Helmi. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMember: UIImageView!
    @IBOutlet weak var fullNameMember: UILabel!
    @IBOutlet weak var professionMember: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
