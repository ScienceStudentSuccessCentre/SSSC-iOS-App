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
        addUIInterruptionMonitor(withDescription: "Allow Notifications") { alert -> Bool in
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
            } else if alert.buttons["Close"].exists {
                snapshot("1EventDetailsWithNotificationAlert")
                alert.buttons["Close"].tap()
            }
            return true
        }
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        
    }
    
    func testEventsTab() {
        app.tabBars.buttons["Events"].tap()
        usleep(networkWait)
        snapshot("0EventsTab")
    }

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
    }

    func testCoursesList() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        snapshot("2CoursesList")
    }

    func testAssignmentsList() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        app.cells.element(boundBy: 1).tap()
        snapshot("3AssignmentsList")
    }

    func testEditCourse() {
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        app.cells.firstMatch.tap()
        app.buttons["EditCourse"].tap()
        snapshot("4EditCourse")
    }

    func testCalculatorList() {
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Calculator"].tap()
        snapshot("5CGPACalculator")
    }
    
}
