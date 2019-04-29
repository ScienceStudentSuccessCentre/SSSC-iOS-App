//
//  CourseTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    @IBOutlet var courseCode: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var grade: UILabel!
    @IBOutlet var gradeView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = gradeView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            gradeView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = gradeView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            gradeView.backgroundColor = color
        }
    }
    
}
