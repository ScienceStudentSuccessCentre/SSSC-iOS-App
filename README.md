# <!-- omit in toc --> Carleton Science Student Success Centre - iOS App

This is the iOS app for the Carleton University Science Student Success Centre. You can find the SSSC Server code [here](https://github.com/ScienceStudentSuccessCentre/SSSC-Server).

- [Project summary](#project-summary)
- [Setting up the workspace](#setting-up-the-workspace)
- [App Store screenshots](#app-store-screenshots)
  - [Using Fastlane](#using-fastlane)
- [Modifying the internal database schema](#modifying-the-internal-database-schema)
- [Documentation for CocoaPods](#documentation-for-cocoapods)

## Project summary

This project is the iOS app for the Science Student Success Centre. It allows students to view all of the events that are shown on the SSSC's website, quickly access the SSSC's resources page, and keep track of their grades using the built-in grade calculator.

Event data is retrieved using a GET request to the SSSC Server (linked above) using the `/events` endpoint, so as to avoid unnecessary parsing and such inside the app.

## Setting up the workspace

1. Clone the repository: https://github.com/ScienceStudentSuccessCentre/SSSC-iOS-App.git
2. Navigate into the directory
3. Run `pod install` (if you don't have CocoaPods installed, you will need to run `sudo gem install cocoapods` first)
4. Open the project using the `ScienceStudentSuccessCentre.xcworkspace` file. **BE AWARE:** if you try to make changes to the project using `ScienceStudentSuccessCentre.xcproj`, none of the external cocoapod dependencies will work.
5. Navigate to the `ScienceStudentSucessCentre` project file in the left sidebar, and select `General`.
6. Make sure the selected team is `Lily Visanuvimol` (the SSSC's account). This will require you to sign in. See any of the SSSC staff for account details.
7. Get the necessary certificates and provisioning profiles from the SSSC staff, and install by double-clicking them.

## App Store screenshots

It can be a tedious task to take all of the necessary screenshots across various simulators. Instead of doing it manually, use the [Fastlane](https://fastlane.tools) command provided below. It will most likely take 20+ minutes to complete, but it will take identical screenshots across devices, using sample grade data, and then frame them in device frames. Note that you can customize how the screenshots are framed by editing `fastlane/screenshots/Framefile.json`. For more info/help with screenshots using Fastlane, as well as information on how to add new screenshot spots / modify existing ones, check out their [screenshots documentation](https://docs.fastlane.tools/getting-started/ios/screenshots).

### Using Fastlane

1. Run `brew cask install fastlane` or `sudo gem install fastlane -NV` to install Fastlane on your machine (I recommend the first one)
   - You may also need to install [Bundler](https://bundler.io). You can do this by running `sudo gem install bundler`
2. Run `bundle exec fastlane screenshots` to take the screenshots (takes time, be patient!)
   - You can also use `bundle exec fastlane` to view all possible "lanes", and execute the screenshots one from there
3. Find the screenshots in `fastlane/screenshots/en-US`

## Modifying the internal database schema

**PLEASE PLEASE PLEASE** be careful when doing this, as you want to make sure you do not cause users to lose their data between updates. Ensure that you thoroughly test the changes you are making *before* you push any updates. Ensure that it will not only read and save data properly upon opening the updated version for the first time, but also that you can completely close the app and restart it without losing any data or duplicating any data. Refer to the [documentation for SQLite.swift](#documentation-for-cocoapods) for details on how to modify the database schema.

## Documentation for CocoaPods

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift) (version 0.12.0)
- [Eureka](https://github.com/xmartlabs/Eureka) (version 5.0.0)
- [PromiseKit](https://github.com/mxcl/PromiseKit) (version 6.8.4)
- [ColorPickerRow](https://github.com/EurekaCommunity/ColorPickerRow)
- [SimulatorStatusMagic](https://github.com/shinydevelopment/SimulatorStatusMagic) (version 2.4.1)
