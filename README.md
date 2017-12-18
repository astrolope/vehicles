### Car Dealership

### Installation

1. Install required dependencies via
`pod install`.

2. Open the .xcworkspace file.

3. Add your development team to the target inside xcode.

### Domain

#### Car Dealership
I chose to build the car dealership app. Utilizing some of the new navigation bar search features in iOS 11. For larger apps I typically use a UIKit replacement such as [Texture](http://texturegroup.org) to prevent weird cell reuse bugs and offer stability with larger data sets. I also noticed that there was no option for automatic vehicles inside the dataset so I have it a placeholder as `isAutomatic` inside the app.

### Interface

#### Web API
There is a web api live at (https://us-central1-itrellis-dealership.cloudfunctions.net/api/vehicles/all) I'm currently only handling one endpoint to return a list of all vehicles with 404, and 500 errors in the event of a server error.

The files for the API live inside the `functions` folder. They are hosted on google cloud platform 

### Platform

#### iOS

### Language

#### Swift
I chose to use Swift for this particular project

### Deployment & Testing
I set up fastlane to deploy the app to Testflight, although it still needs an app icon. Fastlane also offers a framework to generate screenshots for comparison on multiple devices.   



