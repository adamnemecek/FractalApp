//
//  FractalAppTests.swift
//  FractalAppTests
//
//  Created by Tom Briggs on 1/7/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import XCTest
@testable import FractalApp

class FractalAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFracType() {
        
        let model = ModelFactory.getModel()
        
        
        XCTAssert(model.getFractalType() == FractalType.Mandelbrot, "Error - default is unexpected")
        
        XCTAssert(model.setFractalType("Julia"), "Error - failed setting type to Julia")
        XCTAssert(model.getFractalType() == FractalType.Julia, "Error - did not get Julia")
        
        XCTAssert(model.setFractalType("Sierpinksi"), "Error - failed setting type to Sierpinksi")
        XCTAssert(model.getFractalType() == FractalType.Sierpinski, "Error - did not get Sierpinksi")
        
        
        XCTAssert(model.setFractalType("Mandelbrot"), "Error - failed setting type to Mandelbrot")
        XCTAssert(model.getFractalType() == FractalType.Mandelbrot, "Error - did not get Mandelbrot")

        XCTAssert(!model.setFractalType("ZZZZZ"), "Error - failed to detect error")
        XCTAssert(model.getFractalType() == FractalType.Mandelbrot, "Error - should still be Mandelbrot")
        
        
    }
    
    func testPostProgress( ) {
        
        let model = ModelFactory.getModel()
        
        let expectation = expectationWithDescription("waiting for progress")
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("progress", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "progress") && (notification.object is FractalProgress)) {
                    let fp = notification.object as! FractalProgress
                    Swift.print(fp)
                    expectation.fulfill()
            } // end if
        })  // end block & addobserver
        
        let progress = FractalProgress.init(progress: 50.0, lastLine: 100)
        
        model.makeProgress(progress)
        
        waitForExpectationsWithTimeout(10) {
            error in
            
            Swift.print("fail \(error)")
        }
        
        
    }
    
    func testPostRunState( ) {
        
        let model = ModelFactory.getModel()
        
        let expectation = expectationWithDescription("waiting for runState")
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("runState", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "runState") && (notification.object is RunState)) {
                let fp :RunState = notification.object as! RunState
                if (fp.state == RunState.Name.FINISHED) {
                    expectation.fulfill()
                }
            } // end if
        })  // end block & addobserver
        
        let rs = RunState.init(state: RunState.Name.FINISHED)
        
        model.recordRunState(state: rs)
        
        waitForExpectationsWithTimeout(10) {
            error in
            
            Swift.print("fail \(error)")
        }
        
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
            let model = ModelFactory.getModel( )
            
            model.handleWindowResize(NSSize(width: 400, height: 300))
            
            for y in 0 ..< 300
            {
                for x in 0 ..< 400
                {
                    model.setPixel(c: NSColor.init(calibratedHue: 0.5, saturation: 0.3, brightness: 0.5, alpha: 0.7), x: x, y: y)
                }
            }
        }
    }
    
    
    
    func testHandleWindowResize( ) {
        
        let model = ModelFactory.getModel( )
        
        model.handleWindowResize(NSSize(width: 400, height: 300))
        
        XCTAssertEqual(400, model.getWindowSize().width)
        XCTAssertEqual(300, model.getWindowSize().height)
        
        XCTAssertEqual(400, model.getFractalImage().size.width)
        XCTAssertEqual(300, model.getFractalImage().size.height)
        
    }
    
    
    func testFractalRange( ) {
        
        let model = ModelFactory.getModel( )
        
        model.setFractalRange(NSRect(x: -5, y: 27, width: 13, height: 11))

        XCTAssertEqual(-5, model.getFractalRange().origin.x)
        XCTAssertEqual(27, model.getFractalRange().origin.y)
        XCTAssertEqual(13, model.getFractalRange().width)
        XCTAssertEqual(11, model.getFractalRange().height)
        
        XCTAssertTrue(model.getFractalRange().contains(CGPoint(x: 0, y: 30)))
        
    }
    
}
