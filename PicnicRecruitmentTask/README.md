# Picnic Recruitment Task

## Overview

The aim of this project is to develop an iOS app to display and search random GIFs using Giphy endpoints.

## Features

This app has couple of screens with following features,

1. Home screen - This screen is shown on the first app startup. It will display a random GIF and update it every 10 seconds

2. GIF details screen - This screen will display GIF in more detail which includes GIF, its title, URL and PG rating for the current image

## Architecture

The app uses MVVM architecture. The reason being, I wanted to separate out all the business and data transformation logic away from the view layer. The view model is responsible for getting network models (Codable models) and converting them into local view models to be consumed by the view.

The view model interacts with the network layer through protocols and get the required data with network calls via interfaces.

I ruled out MVC due to it polluting the view layer and make it difficult to just test the business logic due to intermixing with view. I also thought about VIPER architecture, but it seemed an overkill for feature this small given the boilerplate code it tends to add. Finally I decided to use MVVM as a middle ground between these two possible alternatives 

## How to run the app?
App can be run simply by opening "PicnicRecruitmentTask.xcworkspace" file and pressing CMD + R to run it

## Tests

 I have written unit tests to test the view model layer and other parts of the app which involves business logic or the data transformation. Tests are written with the mindset to only test the logic layer leaving view layer aside.
 
I didn't add any UI tests in the interest of time, but can be added as a follow-up. My idea around UI tests is we can write UI tests (Including snapshot tests) for individual components and end-to-end tests to verify the flow making sure screens load as expected.

## Device support
 This app is currently supported only on iPhone in the portrait mode
 
 ## Third party images used
 I am using third party images from following sources in the app,
 
 https://hotpot.ai/free-icons?s=sfSymbols
 https://en.wikipedia.org/wiki/Motion_Picture_Association_film_rating_system
 
## Usage of 3rd party library
I am using a 3rd party framework named [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) which is a thread-safe and performant library for downloading and caching GIF images from the remote server. This is due to the complexity involved in reinventing the wheel for caching implementation. (Dependency added via Cocoapods and it's a part of the project. You can just open PicnicRecruitmentTask.xcworkspace file and run the project)  

I tried to use AsyncImage API introduced in iOS 15 to show the static images, but it seemed to have problem loading multiple images in the Grid view and was flaky while scrolling the list of large number of images. Due to this API limitation, I replaced it with SDWebImageSwiftUI API everywhere in the app.

## Deployment Target

App needs minimum version of iOS 14 for the deployment

## Xcode version

App was compiled and run on Xcode version 13.4.1
