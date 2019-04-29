//
//  ColourRestorableCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 4/29/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class ColourRestorableCell: UITableViewCell {
    var colouredView: UIView?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if let view = colouredView {
            let color = view.backgroundColor
            super.setSelected(selected, animated: animated)
            
            if selected {
                view.backgroundColor = color
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if let view = colouredView {
            let color = view.backgroundColor
            super.setHighlighted(highlighted, animated: animated)
            
            if highlighted {
                view.backgroundColor = color
            }
        }
    }
}
