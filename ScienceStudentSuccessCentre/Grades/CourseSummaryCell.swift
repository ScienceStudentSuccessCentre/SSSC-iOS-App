//
//  CourseSummaryCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 4/28/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class CourseSummaryCell: UITableViewCell {
    @IBOutlet var courseColourView: UIView!
    @IBOutlet var termAndCourseCode: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var courseLetterGradeView: UIView!
    @IBOutlet var courseLetterGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseLetterGradeView.addBorders(edges: .left, color: UIColor(.grey), width: 1)
        accessoryType = .disclosureIndicator
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
    
    func configure(with course: Course, term: Term?) {
        courseColourView.backgroundColor = UIColor(course.colour)
        termAndCourseCode.text = (term != nil ? "[\(term!.shortForm)] " : "") + "\(course.code)"
        courseName.text = course.name
        courseLetterGrade.text = course.getLetterGrade()
    }
}
