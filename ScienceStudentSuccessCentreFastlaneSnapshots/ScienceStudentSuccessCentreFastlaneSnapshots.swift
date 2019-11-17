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
    
    var deviceIsPad: Bool {
//        return UIDevice.current.userInterfaceIdiom == .pad
        return false
    }
    
    var deviceOrientationIsPortrait: Bool {
        get {
//            return XCUIDevice.shared.orientation == .portrait
            return true
        }
        set {
            XCUIDevice.shared.orientation = newValue ? .landscapeLeft : .portrait
        }
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UseTestGradeData", "HideTestEvents"]
        addUIInterruptionMonitor(withDescription: "Allow Notifications",
                                 handler: eventDetailsWithNotificationAlertSnapshot(alert:))
        setupSnapshot(app)
        app.launch()
        deviceOrientationIsPortrait = deviceIsPad
    }
    
    @available(iOS 13.0, *)
    func toggleDarkMode(enabled: Bool) {
        app.tabBars.buttons["Settings"].tap()
        if app.switches["RespectSystemDarkMode"].value as? String ?? "0" == "1" {
            app.switches["RespectSystemDarkMode"].tap()
        }
        if app.switches["PermanentDarkMode"].value as? String ?? "0" != (enabled ? "1" : "0") {
            app.switches["PermanentDarkMode"].tap()
        }
    }
    
    func screenshotTitle(forName title: String) -> String {
        if deviceOrientationIsPortrait {
            return title
        }
        return title + "_force_landscapeleft"
    }
    
    // Screenshot 0 - EventsList
    func testEventsTab() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: false)
        }
        app.tabBars.buttons["Events"].tap()
        usleep(networkWait)
        snapshot(screenshotTitle(forName: "0EventsList"))
    }

    // Screenshot 1 - EventsListWithNotification
    func testEventDetailsWithNotificationAlert() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: false)
        }
        app.tabBars.buttons["Events"].tap()
        usleep(networkWait)
        app.cells.element(boundBy: 3).tap()
        usleep(processWait)
        app.buttons["ToggleNotification"].tap()
        usleep(processWait)
        app.tap() // Dismiss notification permissions dialog / notification enabled dialog
        usleep(processWait)
        app.tap() // Dismiss notification enabled dialog (if not already dismissed)
        usleep(processWait)
        app.buttons["ToggleNotification"].tap()
        // The snapshot itself is taken in eventDetailsWithNotificationAlertSnapshot
    }
    
    func eventDetailsWithNotificationAlertSnapshot(alert: XCUIElement) -> Bool {
        if alert.buttons["Allow"].exists {
            alert.buttons["Allow"].tap()
        } else if alert.buttons["Close"].exists {
            snapshot(screenshotTitle(forName: "1EventDetailsWithNotification"))
            alert.buttons["Close"].tap()
        }
        return true
    }

    // Screenshot 2 - CoursesList
    func testCoursesList() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: true)
        }
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        snapshot(screenshotTitle(forName: "2CoursesList"))
    }

    // Screenshot 3 - AssignmentsList
    func testAssignmentsList() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: true)
        }
        app.tabBars.buttons["Grades"].tap()
        app.cells.firstMatch.tap()
        app.cells.element(boundBy: 1).tap()
        snapshot(screenshotTitle(forName: "3AssignmentsList"))
    }
    
    // Screenshot 4 - MentoringTab
    func testMentoringTab() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: false)
        }
        app.tabBars.buttons["Mentoring"].tap()
        usleep(networkWait)
        app.cells.firstMatch.tap()
        snapshot(screenshotTitle(forName: "4MentoringTab"))
    }
    
    // Screenshot 5 - Resources
    func testResources() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: false)
        }
        app.tabBars.buttons["Resources"].tap()
        usleep(networkWait)
        usleep(networkWait)
        snapshot(screenshotTitle(forName: "5Resources"))
    }
    
    // Screenshot 6 - CGPAPlanner
    func testCGPAPlanner() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: true)
        }
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Planner"].tap()
        snapshot(screenshotTitle(forName: "6CGPAPlanner"))
    }

    // Screenshot 7 - CGPACalculator
    func testCalculatorList() {
        if #available(iOS 13.0, *) {
            toggleDarkMode(enabled: true)
        }
        app.tabBars.buttons["Grades"].tap()
        app.buttons["Calculator"].tap()
        snapshot(screenshotTitle(forName: "7CGPACalculator"))
    }
    
}
