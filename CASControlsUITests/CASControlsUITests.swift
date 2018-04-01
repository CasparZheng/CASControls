//
//  CASControlsUITests.swift
//  CASControlsUITests
//
//  Created by Caspar on 3/28/18.
//  Copyright © 2018 Caspar. All rights reserved.
//

import XCTest
@testable import CASControls

class CASControlsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

// MARK: CASButton
extension CASControlsUITests {
    func testLayoutedImageViewAndTitleLabelPosition() {
        class Model {
            var title: String? = nil
            var image: UIImage? = nil
            var type: CASButton.ImagePosition = .left
            var frame: CGRect = CGRect.zero
        }
        
        let images: [UIImage?] = [UIImage.init(named: "sharepage_ic_visualchoice08"), UIImage.init(named: "")]
        let titles: [String?] = ["Custom Button", nil]
        let types: [CASButton.ImagePosition] = [.left, .right, .top, .bottom]
        let frames: [CGRect] = [CGRect(x:0, y:100, width: 20, height: 20), // not enough width, not enough height
                                CGRect(x:0, y:200, width: 100, height: 20), // enough width, not enough height
                                CGRect(x:0, y:300, width: 20, height: 100), // not enough width, enough height
                                CGRect(x:0, y:400, width: 100, height: 100), // enough width, enough height
                                ]
        var models = [Model]()
        for indexTitle in 0..<titles.count {
            for indexImage in 0..<images.count {
                for indexType in 0..<types.count {
                    for indexFrame in 0..<frames.count {
                        let model = Model()
                        model.title = titles[indexTitle]
                        model.image = images[indexImage]
                        model.type = types[indexType]
                        model.frame = frames[indexFrame]
                        models.append(model)
                    }
                }
            }
        }
        
        // use model create view, and then check there frame postion
        // todo
    }
}
