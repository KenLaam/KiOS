//
//  DateCell.swift
//  KCalendar
//
//  Created by Ken Lâm on 10/23/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackground.layer.cornerRadius = 20
    }

}
