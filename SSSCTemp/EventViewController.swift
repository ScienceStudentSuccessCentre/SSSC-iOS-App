//
//  FirstViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-01-19.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    
    var events = [Event]()
    var eventToPass: Event!
    
    @IBOutlet var tableView: UITableView!
    
    let sampleEvent1Description = "If you are interested in programming, join our Coding Challenge! You’ll have the opportunity to work with other students on a small programming project which contains different sections to help guide you along the way. At the end, you will have the chance to present your project with your team and it will be judged based on functionality, creativity and more. There will also be a raffle where everyone has a chance to win, but the winners of the challenge will gain extra raffle tickets.\n\nJudges include: Dr. Michel Barbeau and Dr. Tony White"
    let sampleEvent2Description = "Are you considering Medical School? Come practice your interviewing skills at the Science Student Success Centre. This event is open to anyone who would like to get a feel for what the interview process is like.\n\nSpots fill up quickly, so make sure to sign up as soon as possible. A $5 deposit is required for registration which will be returned once you have attended the event. Please come by the SSSC to drop off the $5 by Monday February 5th. Please plan to arrive 10 minutes early."
    let sampleEvent3Description = "Everyone welcome for a night of skiing or snowboarding!\n\nPrices are listed below, cash only to be bought by noon Jan 25th!\n\nLift ticket and bus: $40\nLift ticket and bus and ski or snowboard rental: $50\nLife ticket and bus and ski or snowboard rental and an intro lesson: $60\n\nA helmet rental is an additional $5.\n\nYou must fill out this registration form online, come in person to the SSSC by January 25th to purchase a ticket, and fill out a waiver form before we can guarantee you a spot."
    
    
    //MARK: Private Methods
    
    private func loadEvents() {
        
    }
    
    private func loadSampleEvents() {
        let sampleEvent1 = Event(name: "Carleton Coding Challenge", description: sampleEvent1Description, month: "Jan", year: 2018, date: 31, time: "4pm", location: "SSSC (3431 Herzberg)")
        let sampleEvent2 = Event(name: "Multiple Mini Interview Practice", description: sampleEvent2Description, month: "Feb", year: 2018, date: 06, time: "6:00pm", location: "SSSC (3431 Herzberg)")
        let sampleEvent3 = Event(name: "Ski Trip: Camp Fortune", description: sampleEvent3Description, month: "Feb", year: 2018, date: 09, time: "4:00pm departure", location: "Camp Fortune")
        
        events += [sampleEvent1, sampleEvent2, sampleEvent3]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell  else {
                        fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        cell.monthLabel.text = events[indexPath.row].month
        cell.dateLabel.text = String(events[indexPath.row].date)
        cell.eventLabel.text = events[indexPath.row].name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25),
                                                                        NSAttributedStringKey.foregroundColor: UIColor.white]
        tableView.delegate = self
        tableView.dataSource = self
        
        loadSampleEvents()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetail" {
            let controller = segue.destination as! EventDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            eventToPass = events[indexPath.row]
            controller.event = eventToPass
        }
    }


}
