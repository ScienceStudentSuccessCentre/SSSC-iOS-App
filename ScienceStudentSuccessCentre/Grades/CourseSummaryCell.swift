//
//  CourseSummaryCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 4/28/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class CourseSummaryCell: ColourRestorableCell {
    @IBOutlet var courseColourView: UIView!
    @IBOutlet var termAndCourseCode: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var courseLetterGradeView: UIView!
    @IBOutlet var courseLetterGrade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colouredView = courseColourView
        courseLetterGradeView.addBorders(edges: .left, color: UIColor(.grey), width: 1)
        accessoryType = .disclosureIndicator
    }
    
    func configure(with course: Course, term: Term?) {
        courseColourView.backgroundColor = UIColor(course.colour)
        termAndCourseCode.text = (term != nil ? "[\(term!.shortForm)] " : "") + "\(course.code)"
        courseName.text = course.name
        courseLetterGrade.text = course.getLetterGrade()
    }
}
