//
//  TestComplex.swift
//  FractalApp
//
//  Created by Tom Briggs on 1/7/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import XCTest


@testable import FractalApp

class TestComplex: XCTestCase {

    func testComplexInit1() {

        let C = Complex.init(real: 1.5, imag: -0.35)
        
        XCTAssert(abs(C.real - 1.5) < 0.001)
        XCTAssert(abs(C.imag - -0.35) < 0.001)
    }

    func testComplexInit2() {
        
        let C = Complex.init(real: 1.5)
        
        XCTAssert(abs(C.real - 1.5) < 0.001)
        XCTAssert(abs(C.imag ) < 0.001)
    }

    
    func testComplexConj() {
        
        let C = Complex.init(real: 1.5, imag: -0.35)
        let conj = C.conj()
        
        XCTAssert(abs(conj.real - 1.5) < 0.1)
        XCTAssert(abs(conj.imag - 0.35) < 0.1)
    }

    
    func testComplexSquared() {
        
        let C = Complex.init(real: 1.5, imag: -0.35)
        let sq = C.squared()
        
        XCTAssert(abs(sq.real - 2.1275) < 0.001)
        XCTAssert(abs(sq.imag - -1.05) < 0.001)
    }
   
    func testL2() {
        
        let C = Complex.init(real: 1.5, imag: -0.35)
        let l2 = C.l2norm()
        
        XCTAssert(abs(l2 - 1.5403) < 0.01, "expected norm \(l2) == 1.5403")
    }

    
    func testAdd() {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        let B = Complex.init(real: -2.25, imag: 3.00)
        
        let C = A + B
        
        XCTAssert(abs(C.real - -1.250) < 0.001)
        XCTAssert(abs(C.imag - 1.750) < 0.001)
    }
    

    func testEqual() {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        let B = Complex.init(real: 1.0001, imag: -1.25)
        let C = Complex.init(real: 1.0, imag: -1.25)
        
        XCTAssert(A == C)
        XCTAssert(!(A == B))
    }


    func testSub() {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        let B = Complex.init(real: -2.25, imag: 3.00)
        
        let C = A - B
        
        XCTAssert(abs(C.real - 3.25) < 0.001, "Expected 3.25 == \(C.real)")
        XCTAssert(abs(C.imag - -4.25) < 0.001, "Expected -4.25 == \(C.imag)")
    }

    func testMul() {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        let B = Complex.init(real: -2.25, imag: 3.00)
        
        let C = A * B
        
        XCTAssert(abs(C.real - 1.5) < 0.001, "Expected 1.5 == \(C.real)")
        XCTAssert(abs(C.imag - 5.8125) < 0.001, "Expected -5.8125 == \(C.imag)")
    }

    func testDiv() {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        let B = Complex.init(real: -2.25, imag: 3.00)
        
        let C = A / B
        
        XCTAssert(abs(C.real - -0.4267) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -0.01333333) < 0.001, "Expected \(C.imag)")
    }
    
    
    func testAddD( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = A + 0.5
        
        XCTAssert(abs(C.real - 1.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -1.25) < 0.001, "Expected \(C.imag)")
    }

    
    func testDAdd( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = 0.5 + A
        
        XCTAssert(abs(C.real - 1.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -1.25) < 0.001, "Expected \(C.imag)")
    }
    
    func testSubD( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = A - 0.5
        
        XCTAssert(abs(C.real - 0.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -1.25) < 0.001, "Expected \(C.imag)")
    }

    func testDSub( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = 0.5 - A
        
        XCTAssert(abs(C.real - -0.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - 1.25) < 0.001, "Expected \(C.imag)")
    }

    
    func testMulD( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = A * 1.5
        
        XCTAssert(abs(C.real - 1.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -1.875) < 0.001, "Expected \(C.imag)")
    }

    func testDMul( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = 1.5 * A
        
        XCTAssert(abs(C.real - 1.5) < 0.001, "Expected \(C.real)")
        XCTAssert(abs(C.imag - -1.875) < 0.001, "Expected \(C.imag)")
    }

    func testDivD( ) {
        
        let A = Complex.init(real: 1.0, imag: -1.25)
        
        let C = A / 1.5
        
        XCTAssert(abs(C.real - 0.667) < 0.001, "Actual \(C.real)")
        XCTAssert(abs(C.imag - -0.833) < 0.001, "Actual \(C.imag)")
    }

    
    
    
}
