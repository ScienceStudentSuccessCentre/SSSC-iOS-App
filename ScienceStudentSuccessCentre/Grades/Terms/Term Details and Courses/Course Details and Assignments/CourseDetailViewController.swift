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
        navigationController?.navigationBar.barTintColor = UIColor(course.colour)
        navigationItem.titleView = getTitleView(title: course.name)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        navigationController?.navigationBar.barTintColor = .darkGray
    }
    
    private func getTitleView (title:String) -> UIView {
        let offset: CGFloat = CGFloat(150)
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - offset, height: 30)
        let titleView = UIView(frame:frame)
        let titleLabel = UILabel(frame: titleView.bounds)
        
        titleLabel.textColor = .white
        titleLabel.text = title
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
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
