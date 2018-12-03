//
//  AssignmentTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet var assignmentName: UILabel!
    @IBOutlet var percentageGrade: UILabel!
    @IBOutlet var letterGrade: UILabel!
    @IBOutlet var letterGradeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setColour(colour: UIColor) {
        letterGradeView.backgroundColor = colour
    }

}
