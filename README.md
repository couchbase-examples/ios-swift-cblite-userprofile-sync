# Quickstart in Couchbase Lite Query with Swift and UIKit 
#### Build an iOS App in Swift with Couchbase Lite 

> This repo is designed to show you an app that allows users to log in and make changes to their user profile information.  User profile information is persisted as a Document in the local Couchbase Lite Database. When the user logs out and logs back in again, the profile information is loaded from the Database.  This app also demostrates how you can bundle, load, and use a `prebuilt` instance of Couchbase Lite and introduces you to the basics of the `QueryBuilder` interface.

Full documentation can be found on the [Couchbase Developer Portal](https://developer.couchbase.com/tutorial-quickstart-ios-uikit-query).


## Prerequisites
To run this prebuilt project, you will need:

- Mac running MacOS 11 or 12 
- Xcode 12/13 - Download latest version from the <a target="_blank" rel="noopener noreferrer" href="https://itunes.apple.com/us/app/xcode/id497799835?mt=12">Mac App Store</a> or via <a target="_blank" rel="noopener noreferrer" href="https://github.com/RobotsAndPencils/XcodesApp">Xcodes</a>

> **Note**: If you are using an older version of Xcode, which you need to retain for other development needs, make a copy of your existing version of Xcode and install the latest Xcode version.  That way you can have multiple versions of Xcode on your Mac.  More information can be found in [Apple's Developer Documentation](https://developer.apple.com/library/archive/technotes/tn2339/_index.html#//apple_ref/doc/uid/DTS40014588-CH1-I_HAVE_MULTIPLE_VERSIONS_OF_XCODE_INSTALLED_ON_MY_MACHINE__WHAT_VERSION_OF_XCODE_DO_THE_COMMAND_LINE_TOOLS_CURRENTLY_USE_)
> 
### Installing Couchbase Lite Framework

The [Couchbase Documentation](https://docs.couchbase.com/couchbase-lite/3.0/swift/gs-install.html) has examples on how to add Couchbase Lite via
- Swift Package Manager
- Cocoa Pods
- Carthage
- Direct Download

## App Architecture

The sample app follows the [MVP pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter), separating the internal data model, from a passive view through a presenter that handles the logic of our application and acts as the conduit between the model and the view

## Try it out

* Open `src/UserProfileQueryDemo.xcodeproj` using Xcode
* Build and run the project.
* Verify that you see the login screen.

## Conclusion

This tutorial walked you through an example of how to use a pre-built Couchbase Lite database and has a simple Query example to show you how to use the `QueryBuilder` API in Swift.
