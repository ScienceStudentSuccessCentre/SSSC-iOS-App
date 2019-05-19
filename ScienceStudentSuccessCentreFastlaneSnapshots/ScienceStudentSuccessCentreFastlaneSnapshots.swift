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
    let networkWait: UInt32 = 2
    let processingWait: UInt32 = 1
    
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
        snapshot("0EventsTab", timeWaitingForIdle: TimeInterval(networkWait))
    }
    
    func testEventDetailsWithNotificationAlert() {
        app.tabBars.buttons["Events"].tap()
        sleep(networkWait)
        app.cells.element(boundBy: 3).tap()
        sleep(processingWait)
        app.buttons["ToggleNotification"].tap()
        sleep(processingWait)
        app.tap() // Dismiss notification permissions dialog / notification enabled dialog
        sleep(processingWait)
        app.tap() // Dismiss notification enabled dialog
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
    
    func testGpaList() {
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Calculator"].tap()
        snapshot("5GpaCalculator")
    }
    
}
