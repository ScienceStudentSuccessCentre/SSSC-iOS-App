//
//  CourseDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    
    var course: Course!
    var assignments = [Assignment]()
    
    private var editCourseButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editCourseButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCoursePressed))
        navigationItem.setRightBarButton(editCourseButton, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dbCourse = Database.instance.getCourseById(id: course.id)
        if (dbCourse != nil) {
            course = dbCourse
        }
        navigationItem.titleView = getTitleView(title: course.name, numOfButtons: 2)
    }
    
    private func getTitleView (title:String, numOfButtons: Int = 0) -> UIView {
        let barButtonSize = 75
        let offset: CGFloat = CGFloat(numOfButtons * barButtonSize)
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - offset, height: 30)
        let titleView = UIView(frame:frame)
        
        let titleLabel = UILabel(frame: titleView.bounds)
        
        titleLabel.backgroundColor = UIColor(course.colour)
        titleLabel.textColor = UIColor.white
        titleLabel.text = title
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5
        titleView.addSubview(titleLabel)
        return titleView
    }
    
    @objc private func editCoursePressed() {
        performSegue(withIdentifier: "editCourse", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCourse" {
            let controller = segue.destination.children.first as! CreateCourseViewController
            controller.course = course
        }
    }
}
