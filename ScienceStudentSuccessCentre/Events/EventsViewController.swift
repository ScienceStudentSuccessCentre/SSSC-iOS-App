//
//  FirstViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, EventObserver, UITableViewDelegate, UITableViewDataSource {
    
    private var events = [Event]()
    private var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    /// Asks the EventParser to start retrieving events from the SSSC website.
    private func loadEvents() {
        DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil).async {
            EventParser.getInstance().loadEvents()
        }
    }
    
    /// Retrieves the latest events from the EventParser and loads them into the tableview.
    func update() {
        events = EventParser.getInstance().getEvents()
        print("Received events")
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            print("Data reloaded")
        }
    }
    
    /// Displays an alert to the user.
    ///
    /// - Parameter alert: The alert to be displayed.
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
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
    
    
    /// Refreshes the events in the tableview at the user's request.
    @objc func refreshEventData() {
        loadEvents()
    }
    
    
    /// Scrolls the user to the top of the event tableview.
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        
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
        
        EventParser.getInstance().attachObserver(observer: self)
        
        loadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail" {
            let controller = segue.destination as! EventDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.event = events[indexPath.row]
        }
    }

}

