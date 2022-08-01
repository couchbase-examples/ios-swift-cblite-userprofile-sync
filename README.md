# Quickstart in Couchbase Lite Sync with Swift and UIKit 
#### Build an iOS App in Swift with Couchbase Lite 

> Couchbase Sync Gateway is a key component of the Couchbase Mobile stack. It is an Internet-facing synchronization mechanism that securely syncs data across devices as well as between devices and the cloud. Couchbase Mobile 3.0 introduces centralized persistent module configuration of synchronization, which simplifies the administration of Sync Gateway clusters — see <a target="_blank" rel="noopener noreferrer" href="https://docs.couchbase.com/sync-gateway/3.0/configuration-overview.html">Sync Gateway Configuration</a>.  

The core functions of the Sync Gateway include

- Data Synchronization across devices and the cloud
- Authorization & Access Control
- Data Validation

This tutorial will demostrate how to 
- Setup the Couchbase Sync Gateway (with Docker) to sync content between multiple Couchbase Lite enabled clients. We will will cover the basics of the Sync Gateway Configuration.
- Configure your Sync Gateway to enforce data routing, access control and authorization. We will cover the basics of Sync Function API
- Configure your Couchbase Lite clients for replication with the Sync Gateway
- Use "Live Queries" or Query events within your Couchbase Lite clients to be asyncronously notified of changes

Full documentation can be found on the <a target="_blank" rel="noopener noreferrer" href="https://developer.couchbase.com/tutorial-quickstart-ios-uikit-sync">Couchbase Developer Portal</a>.


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

* Run `sh install_tutorial.sh` to download specified version of Couchbase Lite framework
* Open `src/UserProfileSyncDemo.xcodeproj` using Xcode
* Drag the `CouchbaseLiteSwift.xcframework` downloaded in Step 1 into the project (do not copy)
* Build and run the project.
* Verify that you see the login screen.

## Conclusion

This tutorial walked you through an example of how to use a Sync Gateway to synchronize data between Couchbase Lite enabled clients. We discussed how to configure your Sync Gateway to enforce relevat access control, authorization and data routing between Couchbase Lite enabled clients.
