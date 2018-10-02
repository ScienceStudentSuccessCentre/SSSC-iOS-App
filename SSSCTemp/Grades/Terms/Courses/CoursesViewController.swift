//
//  CoursesViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var gpa: UILabel!
    @IBOutlet var credits: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var term: Term!
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = term.name
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return courses.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell", for: indexPath) as? CourseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CourseTableViewCell.")
        }
//        let course = courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "courseDetail", sender: self)
    }

}
