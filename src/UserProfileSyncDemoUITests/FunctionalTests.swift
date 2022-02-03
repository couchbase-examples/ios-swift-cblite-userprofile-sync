//  UserProfileDemoUITests
//  Copyright © 2022 Couchbase Inc. All rights reserved.

import XCTest

struct TestingHelper {
    static let TESTUSERNAME: String = "demo@example.com"
    static let TESTUSERNAME2: String = "demo1@example.com"
    static let TESTPASSWORD: String = "password"
    static let TESTFULLNAME: String  = "John Doe"
    static let TESTADDRESS:  String = "123 nowhere street"
    static let TESTUNIVERSITY: String = "Devi Ahilya University of Indore"
    
    static let IDUSERNAME: String = "Username"
    static let IDPASSWORD: String = "Password"
    static let IDLOGIN: String = "idLogin"
    
    static let IDNAME: String = "idName"
    static let IDADDRESS: String = "idAddress"
    static let IDEMAIL: String = "idEmail"
    static let IDUNIVERSITY: String = "idUniversity"
    static let IDUPDATEIMAGE: String = "idUpdateImage"
    static let NAVIGATIONBAR: String = "Your Profile"
    static let UPDATEIMAGEBUTTONTEXT: String = "Update Image"
    static let DONEBUTTON: String = "Done"
    static let LOGOFFBUTTON: String = "Log Off"
    static let OKBUTTON: String = "OK"
    static let SELECTPHOTOBUTTON: String = "Select From Photo Album"
    static let PHOTONAMESELECT: String = "Photo, August 08, 2012, 5:55 PM"
    static let SELECTUNIVERSITYBUTTON: String = "Select University"
    static let UNVERSITYLOOKUPBUTTON: String = "Lookup"
    static let UNIVERSITYSEARCHTEXT: String =  "Dev"
    static let UNIVERSITYCOUNTRYSEARCHTEXT: String = "India"
    static let UNIVERSITYNAMESEARCHTEXTBOX: String = "sbUniversityName"
    static let UNIVERSITYCOUNTRYSEARCHTEXTBOX: String = "sbUniversityCountry"
    static let UNIVERSITYTABLEVIEW: String = "tableView"
    static let UNIVERSITYNAVIGATIONBAR: String = "Search Universities"
}

class FunctionalTests:
    XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApp() throws {
        let app = XCUIApplication()
        app.launch()
        
        //arrange - login demo user
        loginDemoUser(application: app,
            usernameText: TestingHelper.TESTUSERNAME,
            passwordText: TestingHelper.TESTPASSWORD)
       
        //act - update profile
        updateUserProfile(application: app)
        
        //arrange - login demo user
        loginDemoUser(application: app,
                      usernameText: TestingHelper.TESTUSERNAME2,
                      passwordText: TestingHelper.TESTPASSWORD)
        
        //assert - fields are blank because we should be loading a new user
        assertUserProfileDemoUser1(application: app)
       
        //arrange - log back in as demo user and assert values were pulled from db
        loginDemoUser(application: app,
            usernameText: TestingHelper.TESTUSERNAME,
            passwordText: TestingHelper.TESTPASSWORD)
        
        //assert - data was retreived from the database
        assertUserProfileDemoUser(application: app)
    }
    
    //arrange
    func loginDemoUser(
        application: XCUIApplication,
        usernameText: String,
        passwordText: String) {
        
        let username = application.textFields[TestingHelper.IDUSERNAME]
        let password = application.secureTextFields[TestingHelper.IDPASSWORD]
        let btn = application.buttons[TestingHelper.IDLOGIN]
        let systemVersion = UIDevice.current.systemVersion
        
        username.tap()
        username.typeText(usernameText)
        
        //fix for older IOS versions than 15.x
        if (systemVersion.contains("15.")) {
            password.tap()
            password.typeText(passwordText)
        } else {
            password.tap()
            sleep(1)
            UIPasteboard.general.string = passwordText
            password.press(forDuration: 1.5)
            application.menuItems["Paste"].tap()
            sleep(3)
        }

        btn.tap()
        sleep(3)
    }
    
    //assert
    func assertUserProfileDemoUser(application: XCUIApplication) {
        let name = application.textFields[TestingHelper.IDNAME].value as! String
        let address = application.textFields[TestingHelper.IDADDRESS].value as! String
        let email = application.staticTexts[TestingHelper.IDEMAIL].label 
        let university = application.staticTexts[TestingHelper.IDUNIVERSITY].label
        
        let navBar = application.navigationBars[TestingHelper.NAVIGATIONBAR]
        let logOffButton = navBar.buttons[TestingHelper.LOGOFFBUTTON]
       
        //asert
        XCTAssertEqual(name, TestingHelper.TESTFULLNAME)
        XCTAssertEqual(address, TestingHelper.TESTADDRESS)
        XCTAssertEqual(email, TestingHelper.TESTUSERNAME)
        XCTAssertEqual(university, TestingHelper.TESTUNIVERSITY)
        
        logOffButton.tap()
        sleep(5)
    }
    
    //assert
    func assertUserProfileDemoUser1(application: XCUIApplication) {
        let name = application.textFields[TestingHelper.IDNAME].value as! String
        let address = application.textFields[TestingHelper.IDADDRESS].value as! String
        
        let navBar = application.navigationBars[TestingHelper.NAVIGATIONBAR]
        let logOffButton = navBar.buttons[TestingHelper.LOGOFFBUTTON]
       
        //asert
        XCTAssertEqual(name, "Name")
        XCTAssertEqual(address, "Address")
        
        logOffButton.tap()
        sleep(5)
    }
    
    //act
    func updateUserProfile(application: XCUIApplication){
        let name = application.textFields[TestingHelper.IDNAME]
        let address = application.textFields[TestingHelper.IDADDRESS]
        let btnUpdateImage = application.buttons[TestingHelper.IDUPDATEIMAGE]
        let navBar = application.navigationBars[TestingHelper.NAVIGATIONBAR]
        let doneButton = navBar.buttons[TestingHelper.DONEBUTTON]
        let logOffButton = navBar.buttons[TestingHelper.LOGOFFBUTTON]
        let selectUniversityButton = application.buttons[TestingHelper.SELECTUNIVERSITYBUTTON]
        
        name.tap()
        sleep(2)
        name.typeText(TestingHelper.TESTFULLNAME)
        sleep(1)
        
        //dismiss keyboard
        application.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        address.tap()
        sleep(2)
        address.typeText(TestingHelper.TESTADDRESS)
        sleep(1)
        
        //dismiss keyboard
        application.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        //update image - only testing on 15.x because UI is different in older OS
        let systemVersion = UIDevice.current.systemVersion
        
        if (systemVersion.contains("15.")) {
            btnUpdateImage.tap()
            sleep(3)
            application.sheets.scrollViews.otherElements.buttons[TestingHelper.SELECTPHOTOBUTTON].tap()
        
            sleep(4)
            
            application.scrollViews.otherElements.images.firstMatch.tap()
            
            sleep(2)
        }
        
        //update university
        selectUniversityButton.tap()
        selectUniversity(application: application)
        
        doneButton.tap()
        sleep(2)
        
        application.alerts.scrollViews.otherElements.buttons[TestingHelper.OKBUTTON].tap()
        sleep(1)
        
        logOffButton.tap()
    }
    
    func selectUniversity(application: XCUIApplication){
        //arrange
        let navBar = application.navigationBars[TestingHelper.UNIVERSITYNAVIGATIONBAR]
        let doneButton = navBar.buttons[TestingHelper.DONEBUTTON]
        let lookupButton = application.buttons[TestingHelper.UNVERSITYLOOKUPBUTTON]
        let searchName = application.otherElements[TestingHelper.UNIVERSITYNAMESEARCHTEXTBOX]
        let searchCountry = application.otherElements[TestingHelper.UNIVERSITYCOUNTRYSEARCHTEXTBOX]
        let tableView = application.tables[TestingHelper.UNIVERSITYTABLEVIEW]
        
        //act
        searchName.tap()
        searchName.tap()
        sleep(2)
        searchName.typeText(TestingHelper.UNIVERSITYSEARCHTEXT)
       
        searchCountry.tap()
        sleep(2)
        searchCountry.typeText(TestingHelper.UNIVERSITYCOUNTRYSEARCHTEXT)
        
        lookupButton.tap()
        sleep(3)
        
        tableView.cells.element(boundBy: 0).tap()
        sleep(3)
    
        doneButton.tap()
        
    }
    
    func addScreenshot(application: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: application.screenshot())
        attachment.name =  name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
