//
//  FirstViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController {
    private(set) var events = [Event]()
    private var collapseDetailViewController = true
    private var activityIndicatorView: UIActivityIndicatorView!
    
    var noEventsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.view.backgroundColor = .white
        
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.center = view.center
        if #available(iOS 13.0, *) {
            activityIndicatorView.color = .label
        }
        activityIndicatorView.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundView = activityIndicatorView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshEventData), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        
        noEventsLabel = {
            let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
            let label = UILabel(frame: frame)
            label.text = "No events. Check back soon!"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.isHidden = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        tableView.addSubview(noEventsLabel)
        noEventsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noEventsLabel.centerYAnchor.constraint(equalTo: tableView.topAnchor, constant: tableView.frame.height / 5).isActive = true
        
        loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBarAppearance()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// Retrieves the list of events from the SSSC website, and selects the first one on the list when viewing on iPads.
    func loadEvents(deepLinkId: String? = nil, completionHandler: (() -> Void)? = nil) {
        EventLoader.loadEvents().done { events in
            self.events = events
        }.catch { error in
            self.events = [Event]()
            print("Failed to load events:\n\(error)")
            if error.localizedDescription.lowercased().contains("offline") {
                self.presentAlert(kind: .offlineError)
            } else {
                self.presentAlert(kind: .eventsError)
            }
        }.finally {
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
            
            if self.events.count > 0 {
                self.tableView.separatorStyle = .singleLine
                self.noEventsLabel.isHidden = true
                
                if let navigationController = self.splitViewController?.children.last as? UINavigationController,
                    let detailViewController = navigationController.viewControllers.first as? EventDetailViewController {
                    self.tableView.selectRow(at: IndexPath(item: 0, section: 0),
                                             animated: true,
                                             scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
                    detailViewController.event = self.events.first
                }
                
                if let deepLinkId = deepLinkId {
                    self.view.isUserInteractionEnabled = true
                    self.navigateToDeepLinkId(deepLinkId)
                }
            } else {
                self.tableView.separatorStyle = .none
                self.noEventsLabel.isHidden = false
            }
            completionHandler?()
        }
    }
    
    func navigateToDeepLinkId(_ id: String) {
        if let eventIndex = events.firstIndex(where: { $0.id == id }) {
            let indexPath = IndexPath(row: eventIndex, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            performSegue(withIdentifier: "eventDetail", sender: tableView.cellForRow(at: indexPath))
        }
    }
    
    @objc func refreshEventData() {
        loadEvents()
    }
    
    func scrollToTop() {
        if events.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier.contains("eventDetail") {
            if let navigationController = segue.destination as? UINavigationController,
                let detailViewController = navigationController.viewControllers.first as? EventDetailViewController,
                let cell = sender as? EventTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                detailViewController.event = events[indexPath.row]
                detailViewController.isPreview = identifier.contains("Preview")
            }
        }
    }
}

extension EventsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as EventTableViewCell
        let event = events[indexPath.row]
        cell.monthLabel.text = event.monthName
        cell.dateLabel.text = event.dayLeadingZero
        cell.eventLabel.text = event.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.collapseDetailViewController = false
    }
}
