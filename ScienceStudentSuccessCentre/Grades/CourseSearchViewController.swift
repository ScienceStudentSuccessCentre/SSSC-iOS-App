//
//  CourseSearchViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 4/28/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

protocol CourseSearchActionDelegate: AnyObject {
    func didTapCourse(_ course: Course)
}

class CourseSearchViewController: UITableViewController {
    private var results = [Course]()
    private var courses = [Course]()
    private var terms = [Term]()
    private let noResultsLabel = UILabel()
    
    private weak var delegate: CourseSearchActionDelegate?
    
    init(actionDelegate delegate: CourseSearchActionDelegate) {
        self.delegate = delegate
        super.init(style: .plain)
        tableView.register(UINib(nibName: "\(CourseSummaryCell.self)", bundle: nil), forCellReuseIdentifier: "\(CourseSummaryCell.self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        noResultsLabel.text = "No Results"
        noResultsLabel.textAlignment = .center
        tableView.backgroundView = noResultsLabel
        tableView.backgroundColor = UIColor(named: "primaryBackground")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CourseSummaryCell.self)",
            for: indexPath) as? CourseSummaryCell else {
                fatalError("Failed to dequeue \(CourseSummaryCell.self)")
        }
        let course = results[indexPath.row]
        let term = terms.first(where: { $0.id == course.id })
        cell.configure(with: course, term: term)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCourse(results[indexPath.row])
    }
}

extension CourseSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        results = courses.filter({ $0.code.lowercased().contains(query) || $0.name.lowercased().contains(query) })
        tableView.reloadData()
        tableView.separatorStyle = results.count > 0 ? .singleLine : .none
        noResultsLabel.isHidden = results.count > 0
    }
}

extension CourseSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        courses = Database.instance.getCourses()
        terms = Database.instance.getTerms()
    }
}
