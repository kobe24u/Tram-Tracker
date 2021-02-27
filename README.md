## Requirements

- iOS 13.0+
- Xcode 12+
- Swift 5.2+


## Setup

1. Download the source code or clone the repository.
2. Run the project.
3. Open a terminal and cd to the directory containing the Podfile
4.  Run the `pod install` command

(For further details regarding cocoapod installation see https://cocoapods.org/)


## Introduction

This is a simple app that consumes TramTracker API to get the upcoming trams going *north* and *south* outside the REA office on Church St. There is a single table view with two sections, one for north and one for south. The app will start to make the get request automatically in the first launch. There is a timer working in the background that will refresh the ETA in the tableView cell to give user the most up to date information. User can always choose to pull the tableView to refresh or simply just tap the refresh button at the top right corner. User can also tap the clear button at the top left corner to empty the tableView.

The app has a MVVM architecture, files are put inside relating folders for a better strucutre, API manager along with APIEndpoints are like the network router of this app, viewModel will do most of the dirty job, viewController should be dumb enough to just render components, closure is the bridge between ViewModel and ViewController, ViewModel will notify ViewController when to reload UI(tableView). There is no strong reference inside closures, retain cycle has been avoided. All raw messages and some global immutable variables have been put inside a constants class for easy access. Error handling has been put in place, for most of the common errors, the app is now able to capture and present a meaningful message, for those ambiguous unknown errors, app will just present the raw error message using AlertViewController. All models are codable and the app is using UserDefaults as the token storage solution.

17 Unit Tests have been done purely using Nimble and Quick.

## Frameworks

- [Nimble](https://github.com/Quick/Nimble)
- [Quick](https://github.com/Quick/Nimble)


