//
//  TramDetailsTableViewCell.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import UIKit

class TramDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var destLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(tram: Tram){
        destLabel.text = tram.destination
        etaLabel.text = DotNetDateConverter().formattedDateFromString(tram.arrivalDate ?? "")
    }
}
