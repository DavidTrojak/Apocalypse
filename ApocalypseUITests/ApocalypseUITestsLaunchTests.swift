//
//  ApocalypseUITestsLaunchTests.swift
//  ApocalypseUITests
//
//  Created by David Trojak on 08.01.2023.
//

@testable import Apocalypse
import XCTest

final class ApocalypseUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        
        let btnView = app.otherElements["User location btn"]
        
        XCTAssertFalse(btnView.isHittable)
    
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
