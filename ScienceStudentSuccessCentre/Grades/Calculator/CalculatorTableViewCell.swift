//
//  CalculatorTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-30.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CalculatorTableViewCell: UITableViewCell {

    @IBOutlet var courseColourView: UIView!
    @IBOutlet var termAndCourseGrade: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var courseLetterGradeView: UIView!
    @IBOutlet var courseLetterGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseLetterGradeView.addBorders(edges: .left, color: UIColor(.grey), width: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = courseColourView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            courseColourView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = courseColourView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            courseColourView.backgroundColor = color
        }
    }

}
