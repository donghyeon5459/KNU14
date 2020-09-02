//
//  COVIDDetailCell.swift
//  AvoidCoronaApp
//
//  Created by 윤영신 on 2020/06/10.
//  Copyright © 2020 Azderica. All rights reserved.
//

import UIKit

class COVIDDetailCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var caseLabel: UILabel!
    @IBOutlet weak var nowcaseLabel: UILabel!
    @IBOutlet weak var deathLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
