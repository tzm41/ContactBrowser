//
//  PersonTableViewCell.swift
//  ContactBrowser
//
//  Created by Zhuoming Tan on 6/7/16.
//  Copyright © 2016 Intrepid Pursuilts LLC. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
