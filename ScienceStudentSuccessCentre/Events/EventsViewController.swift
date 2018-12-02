//
//  FirstViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, EventObserver, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    private var events = [Event]()
    private var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: Private Methods
    
    private func loadEvents() {
        DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil).async {
            EventParser.getInstance().loadEvents()
        }
    }
    
    func update() {
        events = EventParser.getInstance().getEvents()
        print("Received events")
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
            print("Data reloaded")
        }
    }
    
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
    
    @objc func refreshEventData(_ sender: Any) {
        loadEvents()
    }
    
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        EventParser.getInstance().attachObserver(observer: self)
        
        tableView.separatorStyle = .none
        tableView.backgroundView = activityIndicatorView
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshEventData(_:)), for: .valueChanged)
        
        loadEvents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail" {
            let controller = segue.destination as! EventDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.event = events[indexPath.row]
        }
    }

}

