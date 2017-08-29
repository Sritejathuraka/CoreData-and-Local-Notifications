//
//  DetailTableViewCell.swift
//  CalenderTriggerDemo
//
//  Created by Sriteja Thuraka on 8/1/17.
//  Copyright © 2017 Sriteja Thuraka. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
