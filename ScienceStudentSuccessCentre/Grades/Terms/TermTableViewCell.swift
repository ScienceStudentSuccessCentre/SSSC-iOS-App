//
//  TermTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermTableViewCell: ColourRestorableCell {
    @IBOutlet var termName: UILabel!
    @IBOutlet var termAbbr: UILabel!
    @IBOutlet var termView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colouredView = termView
        termView.layer.cornerRadius = 3
    }
}
