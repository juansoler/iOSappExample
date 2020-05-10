//
//  MemberCell.swift
//  LPS2020
//
//  Created by Juan Soler Marquez on 07/01/2020.
//  Copyright © 2020 ual. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var nombre: UILabel!

}
