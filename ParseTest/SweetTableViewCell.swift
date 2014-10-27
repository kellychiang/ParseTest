//
//  SweetTableViewCell.swift
//  ParseTest
//
//  Created by kelly on 2014/10/15.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class SweetTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel! = UILabel()
    @IBOutlet weak var timestampLabel: UILabel! = UILabel()
    @IBOutlet weak var sweetTextView: UITextView! = UITextView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
