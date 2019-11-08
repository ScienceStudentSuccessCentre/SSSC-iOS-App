//
//  MentorSearchViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

protocol MentorSearchActionDelegate: AnyObject {
    func getMentors() -> [Mentor]
    func didTapMentor(_ mentor: Mentor)
}

class MentorSearchViewController: UITableViewController {
    private var results = [Mentor]()
    private var mentors = [Mentor]()
    private let noResultsLabel = UILabel()
    
    private weak var delegate: MentorSearchActionDelegate?
    
    init(actionDelegate delegate: MentorSearchActionDelegate) {
        super.init(style: .plain)
        self.delegate = delegate
        tableView.register(UINib(nibName: "\(MentorSearchCell.self)", bundle: nil), forCellReuseIdentifier: "\(MentorSearchCell.self)")
    }
    
    required init?(coder: NSCoder) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MentorSearchCell.self)",
            for: indexPath) as? MentorSearchCell else {
                fatalError("Failed to dequeue \(MentorSearchCell.self)")
        }
        let mentor = results[indexPath.row]
        cell.configure(with: mentor)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapMentor(results[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MentorSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        results = mentors.filter { mentor in
            mentor.name.lowercased().contains(query)
                || mentor.degree.lowercased().contains(query)
                || mentor.team.lowercased().contains(query)
        }
        tableView.reloadData()
        tableView.separatorStyle = results.count > 0 ? .singleLine : .none
        noResultsLabel.isHidden = results.count > 0
    }
}

extension MentorSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mentors = delegate?.getMentors() ?? [Mentor]()
    }
}
