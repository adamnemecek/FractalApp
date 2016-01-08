//
//  TestMandelbrot.swift
//  FractalApp
//
//  Created by Tom Briggs on 1/7/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import XCTest

@testable import FractalApp

class TestMandelbrot: XCTestCase {


    func testMandelbrot() {

        let M = Mandelbrot( )
        
        let p = M.calcMandPoint(100.0, y: 100.0)
        
        XCTAssert(p == 1, "Expected \(p)")
        
    
    }

    func testMandelbrot1() {
        
        let M = Mandelbrot( )
        
        let p = M.calcMandPoint(0.05, y: -0.1)
        
        XCTAssert(p == 1000, "Expected \(p)")
        
        
    }
  
}
