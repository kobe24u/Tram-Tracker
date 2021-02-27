//
//  TramMissingTableViewCell.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import UIKit

class TramMissingTableViewCell: UITableViewCell {

    @IBOutlet weak var msgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(msg: String){
        self.msgLabel.text = msg
    }
}
