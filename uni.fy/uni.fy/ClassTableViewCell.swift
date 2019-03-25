//
//  ClassTableViewCell.swift
//  uni.fy
//
//  Created by Saarila Kenkare on 3/13/19.
//  Copyright © 2019 Priya Patel. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
