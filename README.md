# <!-- omit in toc --> Carleton Science Student Success Centre - iOS App

This is the iOS app for the Carleton University Science Student Success Centre. You can find the SSSC Server code [here](https://github.com/ScienceStudentSuccessCentre/SSSC-Server), and the Android equivalent [here](https://github.com/ScienceStudentSuccessCentre/SSSC-Android-app).

- [Project summary](#project-summary)
- [Getting started](#getting-started)
  - [Downloading the project](#downloading-the-project)
  - [Setting up the development environment](#setting-up-the-development-environment)
- [Uploading to the App Store](#uploading-to-the-app-store)
  - [Part 1: Creating a new app version in App Store Connect](#part-1-creating-a-new-app-version-in-app-store-connect)
  - [Part 2: Uploading the app from Xcode](#part-2-uploading-the-app-from-xcode)
  - [Part 3: Filling in app details on App Store Connect](#part-3-filling-in-app-details-on-app-store-connect)
  - [App Store screenshots](#app-store-screenshots)
- [Modifying the internal Grades database schema](#modifying-the-internal-grades-database-schema)
- [Documentation for CocoaPods](#documentation-for-cocoapods)

## Project summary

This project is the iOS app for the Science Student Success Centre. It allows students to view all of the events that are shown on the SSSC's website, quickly access the SSSC's resources page, view mentors and book appointments, and keep track of their grades using the built-in grade calculator.

Event and mentor data is retrieved using GET requests to the SSSC Server (linked above) using the `/events` and `/mentors` endpoints, in order to avoid unnecessary parsing and such inside the app.

## Getting started

There are a few different steps you'll need to go through to work on the app. Of course, it goes without saying that you should have Xcode installed before you get started! You can get it either from Apple's website or from the App Store. Once you've got that on your computer, you can get started.

### Downloading the project

The first thing you'll need to do in order to work on the app is to download it! Here are the steps to get it onto your machine properly.

1. Clone the repository: `git clone https://github.com/ScienceStudentSuccessCentre/SSSC-iOS-App.git`
2. Navigate into the `SSSC-iOS-App` directory
3. Make sure you have [CocoaPods](https://cocoapods.org) installed by running `pod --version`
   - If it's not installed, you can run `sudo gem install cocoapods` to install it
4. Run `pod install` to install all of the dependencies for this project
5. Open the project in Xcode using the `ScienceStudentSuccessCentre.xcworkspace` file.

> **BE AWARE:** if you try to make changes to the project using `ScienceStudentSuccessCentre.xcodeproj`, none of the external dependencies that you just installed will work

### Setting up the development environment

The next thing you'll need to do it ensure Xcode is set up properly for this project! Here are the steps.

1. Ask Anisha for the Developer Profile file (called `SSSC.developerprofile`)
2. Double-click the file and enter the password Anisha gave you
   - Note that if you enter the incorrect password, no error message will be shown. Just try again!
3. Once the account appears, click on `Sign In Again` and enter the password for the SSSC Apple ID
   - Ask Anisha for this account information! Her phone is set up with 2-factor authentication
   - **IMPORTANT:** If you don't see the `Sign In Again` button, click on the `General` tab, then go back to `Accounts` and it should appear. This seems to be a bug in Xcode

Congratulations! Everything should now be set up. Close the Preferences pane, select a simulator in the top bar, hit the run button, and you should be able to see it in action.

## Uploading to the App Store

You've been working on a new feature or a bug fix, and you're ready to upload it to the App Store! Great job 😄! Here are the steps you'll need to take in order to upload a new build to the App Store and release it.

>Quick note: you can save time taking screenshots by checking out the [App Store screenshots](#app-store-screenshots) section below!

### Part 1: Creating a new app version in App Store Connect

The first thing you'll need to do is create a new version of the app on [App Store Connect](https://appstoreconnect.apple.com), which is Apple's online app manager.

1. Log in with the SSSC Apple ID
   - Ask Anisha for this account information! Her phone is set up with 2-factor authentication
2. Go to `My Apps -> Science Student Success Centre`
3. On the left sidebar, click `(+) Version or Platform`, and give it a version number (e.g. 1.7)
   - This should be incremented from the current version that's on the App Store, which you should be able to see in the left sidebar as well

Great! Now we have a place that the app can be uploaded to. Let's return to Xcode.

### Part 2: Uploading the app from Xcode

The next thing we need to do is upload the app to App Store Connect! This is done from within Xcode.

1. Click on the `ScienceStudentSucessCentre` project file in the left sidebar
2. In the top left of the area that shows up, make sure the `ScienceStudentSuccessCentre` target is selected (the one with the red icon)
3. Select `General` along the top
4. Increment the Build number, and set the Version number to the same value that you entered on App Store Connect
5. Select the target called `ScienceStudentSuccessCentreGradesFile` (the one with the white circle with an E inside)
6. Set the Build number and Version to the same values as above
7. Along the very top, click the dropdown where you choose a simulator, then select `Generic iOS Device`
8. In the menu bar, select `Product -> Archive`. This will take a litte bit
9. The Organizer pane will pop up. Choose `Distribute App` in the right sidebar
10. Keep hitting Next, Continue, etc. to keep the default selections for everything
11. Finally, hit Upload to send the build to App Store Connect! This should take a minute or two

Awesome! Once it's uploaded, the build should take around half an hour to process. The SSSC will receive an email when it's done processing - ask a member of the SSSC staff to let you know when it's done, then move on to Part 3.

### Part 3: Filling in app details on App Store Connect

Now that the build is uploaded, you need to fill in any information about it! Return to [App Store Connect](https://appstoreconnect.apple.com) and log in like in Part 1. After each step, make sure to hit `Save` in the top right (*not* `Submit for Review`)!

1. With the new version of the app selected in the left sidebar, fill in the "What's New in This Version" box. Be descriptive of what changed, but not too technical, and try to keep the tone friendly and warm!
2. Upload some screenshots under "App Previews and Screenshots". This needs to be done for all four device classes.
   - Don't want to take screenshots manually? Check out the [App Store screenshots](#app-store-screenshots) section below!
3. Scroll down to the "Build" section, and choose the build that you uploaded
4. Scroll down further to the "Version Release" section, and choose how you want to release the app once it's approved
5. **DOUBLE CHECK EVERYTHING!!!**
6. Click `Submit for Review` in the top right!

Congratulations! You've released a new version of the app! 🎉🎉🎉

### App Store screenshots

It can be a tedious task to take all of the necessary screenshots across various simulators. Instead of doing it manually, you can use [Fastlane](https://fastlane.tools). It will most likely take a while to complete (i.e. 15+ minutes), but it will take identical screenshots across devices, using sample grade data, and then frame them in device frames. Note that you can customize how the screenshots are framed by editing `fastlane/screenshots/Framefile.json`. For more info/help with screenshots using Fastlane, as well as information on how to add new screenshot spots / modify existing ones, check out their [screenshots documentation](https://docs.fastlane.tools/getting-started/ios/screenshots).

1. Make sure you have [Homebrew](https://brew.sh) installed by running `brew --version`
   - If it's not installed, you can run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"` to install it
2. Make sure you have [Bundler](https://bundler.io) installed by running `bundle --version`
   - If it's not installed, you can run `sudo gem install bundler` to intall it
3. Run `brew cask install fastlane` to install Fastlane on your machine
4. Run `bundle install` to set up Fastlane with Bundler
5. Run `brew install libpng jpeg imagemagick` to install [ImageMagick](https://imagemagick.org/index.php), the software that frames the screenshots with iOS devices
6. Run `bundle exec fastlane screenshots` to take the screenshots (takes time, be patient!)
   - You can also use `bundle exec fastlane` to view all possible "lanes", and execute the screenshots one from there
   - If you get an error related to passing invalid arguments to capture_screenshot, try running `sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer` to ensure that Fastlane knows where your Xcode app is located on your computer
7. Find the completed screenshots in `fastlane/screenshots/en-US`

## Modifying the internal Grades database schema

**PLEASE PLEASE PLEASE** be careful when doing this, as you want to make sure you do not cause users to lose their data between updates. Ensure that you thoroughly test the changes you are making *before* you push any updates. Ensure that it will not only read and save data properly upon opening the updated version for the first time, but also that you can completely close the app and restart it without losing any data or duplicating any data. Refer to the [documentation for SQLite.swift](#documentation-for-cocoapods) for details on how to modify the database schema.

## Documentation for CocoaPods

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift) (version 0.12.0)
- [Eureka](https://github.com/xmartlabs/Eureka) (version 5.0.0)
- [PromiseKit](https://github.com/mxcl/PromiseKit) (version 6.8.4)
- [ColorPickerRow](https://github.com/EurekaCommunity/ColorPickerRow)
- [SwiftLint](https://github.com/realm/SwiftLint)
