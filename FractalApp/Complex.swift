//
//  Complex.swift
//  FirstApp
//
//  Created by Tom Briggs on 12/28/15.
//  Copyright © 2015 Tom Briggs. All rights reserved.
//

import Foundation

public struct Complex {
    
    var real = 0.0
    var imag = 0.0
    
    public init(real: Double, imag: Double)
    {
        self.real = real;
        self.imag = imag;
    }
    
    public init(real: Double)
    {
        self.real = real;
        self.imag = 0;
    }
    
    
    public func conj( ) -> Complex
    {
        return Complex(real: self.real, imag: -self.imag);
    }
    
    public func squared( ) -> Complex
    {
        return Complex(real: (real * real) - (imag * imag),
            imag: 2 * real * imag)
    }
    
    public func l2norm( ) -> Double
    {
        return sqrt( (real*real) + (imag * imag) )
    }

    public func dot( ) -> Double
    {
        return (real * real) + (imag * imag)
    }
}

public func ==(left: Complex, right: Complex) -> Bool {
    return (left.real == right.real) && (left.imag == right.imag)
}

public func +(left: Complex, right: Complex) -> Complex {
    return Complex(real: right.real + left.real, imag: right.imag + left.imag)
}

public func -(left: Complex, right: Complex) -> Complex {
    return Complex(real: left.real - right.real, imag: left.imag - right.imag)
}


public  func *(left: Complex, right: Complex) -> Complex {
    return Complex(real: (left.real * right.real) - (left.imag * right.imag),
        imag: (left.imag * right.real) + (left.real * right.imag))
}

public func /(left: Complex, right: Complex) -> Complex {
    let den : Double = (right.real * right.real) + (right.imag * right.imag)
    
    let r: Double = (left.real * right.real) + (left.imag * right.imag)
    let i: Double = (left.imag * right.real) - (left.real * right.imag)
    
    return Complex( real: r/den, imag: i / den)
}


public func +(left: Complex, right: Double) -> Complex {
    return Complex(real: left.real + right, imag: left.imag)
}

public func +(left: Double, right: Complex) -> Complex {
    return Complex(real: right.real + left, imag: right.imag)
}


public func -(left: Complex, right: Double) -> Complex {
    return Complex(real: left.real - right, imag: left.imag)
}

public func -(left: Double, right: Complex) -> Complex {
    return Complex(real: left - right.real, imag: -right.imag)
}


public func *(left: Complex, right: Double) -> Complex {
    return Complex( real: left.real * right, imag: (left.imag * right))
}

public func *(left: Double, right: Complex) -> Complex {
    return Complex( real: right.real * left, imag: (right.imag * left))
}


public func /(left: Complex, right: Double) -> Complex {
   let den : Double = (right * right)
    
    return Complex( real: ((left.real * right))/den,
        imag: ((left.imag * right))/den)
}

