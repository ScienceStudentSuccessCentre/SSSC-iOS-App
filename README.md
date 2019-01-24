# <!-- omit in toc --> Carleton Science Student Success Centre - iOS App

This is the iOS app for the Carleton University Science Student Success Centre. You can find the SSSC Server code [here](https://github.com/ScienceStudentSuccessCentre/SSSC-Server).

- [Project summary](#project-summary)
- [Setting up the workspace](#setting-up-the-workspace)
- [Brief overview of the internal workings](#brief-overview-of-the-internal-workings)
- [Modifying the internal database](#modifying-the-internal-database)
- [Documentation for cocoa pods (third-party libraries)](#documentation-for-cocoa-pods-third-party-libraries)

## Project summary

This project is the iOS app for the Science Student Success Centre. It allows students to view all of the events that are shown on the SSSC's website, quickly access the SSSC's resources page, and keep track of their grades using the built-in grade calculator.

Event data is retrieved using a GET request to the SSSC Server (linked above) using the `/events` endpoint, so as to avoid unnecessary parsing and such inside the app.

## Setting up the workspace

1. Clone the repository: https://github.com/ScienceStudentSuccessCentre/SSSC-iOS-App.git
2. Navigate into the directory
3. Run `pod install`
4. Open the project using the `ScienceStudentSuccessCentre.xcworkspace` file. **BE AWARE:** if you try to make changes to the project using `ScienceStudentSuccessCentre.xcproj`, none of the external cocoapod dependencies will work.
5. Navigate to the `ScienceStudentSucessCentre` project file in the left sidebar, and select `General`.
6. Make sure the selected team is `Lily Visanuvimol` (the SSSC's account). This will require you to sign in. See any of the SSSC staff for account details.
7. Get the necessary certificates and provisioning profiles from the SSSC staff, and install by double-clicking them.

## Brief overview of the internal workings

- All complex data objects belonging to the model (`Event`, `Term`, `Course`, etc.) are stored in the `Model` folder
- Everything related to the `Events` tab is done in the `Events` folder, `Grades` tab in `Grades` folder, etc.
- Convenience functions and Extensions are found in the `Utilities and Extensions` folder

## Modifying the internal database

**PLEASE PLEASE PLEASE** be careful when doing this, as you want to make sure you do not cause users to lose their data between updates. Ensure that you thoroughly test the changes you are making *before* you push any updates. Ensure that it will not only read and save data properly upon opening the updated version for the first time, but also that you can completely close the app and restart it without losing any data or duplicating any data. Refer to the [documentation for SQLite.swift](#documentation-for-cocoa-pods-third-party-libraries) for details on how to modify the database schema.

## Documentation for cocoa pods (third-party libraries)

- [SwiftSoup](https://github.com/scinfu/SwiftSoup) (version 1.7.4)
- [Alamofire](https://github.com/Alamofire/Alamofire) (version 4.8.0)
- [SQLite.swift](https://github.com/stephencelis/SQLite.swift) (version 0.11.5)
- [Eureka](https://github.com/xmartlabs/Eureka) (version 4.3.0)
- [PromiseKit](https://github.com/mxcl/PromiseKit) (version 6.7.1)
- [ColorPickerRow](https://github.com/EurekaCommunity/ColorPickerRow) (version 1.2.1, although this is not a part of the native cocoapods library, so version will not be necessarily match when running `pod install`)
