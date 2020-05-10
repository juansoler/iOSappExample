//
//  CaseUserTableViewCell.swift
//  LPS2020
//
//  Created by Bruno on 05/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit

class CaseUserTableViewCell: UITableViewCell {

    @IBOutlet weak var caseNameLbl: UILabel!
    @IBOutlet weak var numSamplesLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
