//
//  ScienceStudentSuccessCentreFastlaneSnapshots.swift
//  ScienceStudentSuccessCentreFastlaneSnapshots
//
//  Created by Avery Vine on 2019-05-19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import XCTest

class ScienceStudentSuccessCentreFastlaneSnapshots: XCTestCase {
    var app: XCUIApplication!
    let networkWait: useconds_t = 1000000 // 1 second - purpose is to allow for slow networks
    let processWait: useconds_t = 500000 // 0.5 seconds - purpose is to allow UI elements to (dis)appear
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UseTestGradeData", "HideTestEvents", "CleanStatusBar"]
        addUIInterruptionMonitor(withDescription: "Allow Notifications",
                                 handler: eventDetailsWithNotificationAlertSnapshot(alert:))
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        
    }
    
    // Screenshot 0 - EventsList
    func testEventsTab() {
        app.tabBars.buttons["Events"].tap()
        usleep(networkWait)
        snapshot("0EventsList")
    }

    // Screenshot 1 - EventsListWithNotification
    func testEventDetailsWithNotificationAlert() {
        app.tabBars.buttons["Events"].tap()
        usleep(networkWait)
        app.cells.element(boundBy: 3).tap()
        usleep(processWait)
        app.buttons["ToggleNotification"].tap()
        usleep(processWait)
        app.tap() // Dismiss notification permissions dialog / notification enabled dialog
        usleep(processWait)
        app.tap() // Dismiss notification enabled dialog (if not already dismissed)
        app.buttons["ToggleNotification"].tap()
        // The snapshot itself is taken in eventDetailsWithNitificationAlertSnapshot
    }
    
    func eventDetailsWithNotificationAlertSnapshot(alert: XCUIElement) -> Bool {
        if alert.buttons["Allow"].exists {
            alert.buttons["Allow"].tap()
        } else if alert.buttons["Close"].exists {
            snapshot("1EventDetailsWithNotification")
            alert.buttons["Close"].tap()
        }
        return true
    }

    // Screenshot 2 - CoursesList
    func testCoursesList() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        snapshot("2CoursesList")
    }

    // Screenshot 3 - AssignmentsList
    func testAssignmentsList() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        app.cells.element(boundBy: 1).tap()
        snapshot("3AssignmentsList")
    }

    // Screenshot 4 - EditCourse
    func testEditCourse() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        app.cells.firstMatch.tap()
        app.buttons["EditCourse"].tap()
        snapshot("4EditCourse")
    }
    
    // Screenshot 5 - Resources
    func testResources() {
        app.tabBars.buttons["Resources"].tap()
        usleep(networkWait)
        usleep(networkWait)
        snapshot("5Resources")
    }
    
    // Screenshot 6 - CGPAPlanner
    func testCGPAPlanner() {
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Planner"].tap()
        snapshot("6CGPAPlanner")
    }

    // Screenshot 7 - CGPACalculator
    func testCalculatorList() {
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Calculator"].tap()
        snapshot("7CGPACalculator")
    }
    
}
