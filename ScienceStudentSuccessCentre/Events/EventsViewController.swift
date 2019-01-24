//
//  FirstViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource {
    
    private var events = [Event]()
    private var collapseDetailViewController = true
    private var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.view.backgroundColor = .white
        self.splitViewController?.delegate = self
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundView = activityIndicatorView
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshEventData), for: .valueChanged)
        
        loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    /// Retrieves the list of events from the SSSC website, and selects the first one on the list when viewing on iPads.
    private func loadEvents() {
        EventLoader.loadEvents().done { events in
            self.events = events
            if let navigationController = self.splitViewController?.children.last as? UINavigationController,
                let detailViewController = navigationController.viewControllers.first as? EventDetailViewController {
                self.tableView.selectRow(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
                detailViewController.event = self.events.first
            }
            }.catch { error in
                print("Failed to load events:\n\(error)")
                let alert = UIAlertController(title: "Something went wrong!", message: "Something went wrong when loading the SSSC's upcoming events! Please try again later. If the issue persists, contact the SSSC so we can fix the problem as soon as possible.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }.finally {
                self.activityIndicatorView.stopAnimating()
                self.tableView.separatorStyle = .singleLine
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
        }
    }
    
    /// Refreshes the events in the tableview at the user's request.
    @objc func refreshEventData() {
        loadEvents()
    }
    
    /// Scrolls the user to the top of the event tableview.
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail" {
            if let navigationController = segue.destination as? UINavigationController,
                let detailViewController = navigationController.viewControllers.first as? EventDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailViewController.event = events[indexPath.row]
            }
        }
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        let event = events[indexPath.row]
        cell.monthLabel.text = event.getMonthName()
        cell.dateLabel.text = event.getDayLeadingZero()
        cell.eventLabel.text = event.getName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.collapseDetailViewController = false
    }
}

extension EventsViewController: UISplitViewControllerDelegate {
    /// This is to ensure that smaller devices (like iPhones) will show the master view (this view controller) first, before any detail views.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
