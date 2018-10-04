//
//  CourseTableViewCell.swift
//  SSSCTemp
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
