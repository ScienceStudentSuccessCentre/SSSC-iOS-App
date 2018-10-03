//
//  TermTableViewCell.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermTableViewCell: UITableViewCell {
    
    @IBOutlet var termName: UILabel!
    @IBOutlet var termAbbr: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
