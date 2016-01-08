//
//  Mandelbrot.swift
//  FirstApp
//
//  Created by Tom Briggs on 12/28/15.
//  Copyright © 2015 Tom Briggs. All rights reserved.
//

import Foundation
import Cocoa
import EventKit

class Mandelbrot {
    
    static let defaultRange = NSRect(x: -2, y: -1.5, width: 2.5, height: 3)
    
    
    func run( )
    {
        let model = ModelFactory.getModel()

        model.makeProgress(FractalProgress.init(progress: 0.0, lastLine: 0))
        
        let numPixelsY = Int(model.getWindowSize().height)
        let numPixelsX = Int(model.getWindowSize().width)
        
        let virtWidth = (model.getFractalRange().width)
        let virtHeight = (model.getFractalRange().height)
        
        let stepY = Double(virtHeight) / Double(model.getWindowSize().height)
        let stepX = Double(virtWidth) / Double(model.getWindowSize().width)
        
        var vy = Double(model.getFractalRange().minY)
        
        var lastPercent : Double = 0.0
        
        Swift.print("Generating mandelbrot for \(numPixelsX)x\(numPixelsY)")
        
        for var y = 0; y < numPixelsY; y++
        {
            var vx = Double(model.getFractalRange().minX)
            
            for var x = 0; x < numPixelsX; x++
            {
                let c = calcMandPoint(vx, y:vy)
                let i = ColorMap.mapColor(c)

                model.setPixel(c: i, x: x, y: y)

                vx += stepX;
            }
            
            vy = vy + stepY
            let dy = Double(y) / Double(numPixelsY);
            
            let pcnt = dy * 100.0;
            if ((pcnt - lastPercent) > 10.0) {
                model.makeProgress(FractalProgress.init(progress: pcnt, lastLine: y));
                lastPercent = pcnt
            }
            
        }
        
        model.makeProgress(FractalProgress.init(progress: 100.0, lastLine: numPixelsY));
        model.recordRunState(state: RunState.init(state: RunState.Name.FINISHED))
        Swift.print("Mandelbrot finished")
    }
    
    func calcMandPoint(x:Double, y:Double) -> Int {
        
        let C = Complex(real: Double(x), imag: Double(y))
        var Z = Complex(real: 0.0, imag: 0.0)
        
        var count:Int = 0
        
        repeat {
            
            Z = Z.squared() + C
            count = count + 1;
            
        } while( (Z.dot() < 4) && (count < 1000))
        
        return count
    }
    
    
    struct ColorMap {
        
        
        static func mapColor(C:Int) -> NSColor
        {
            let hue = CGFloat(C)/256.0
            let sat = CGFloat(0.8)
            let bright = CGFloat(1.0) - (hue * hue)
            
            return NSColor(calibratedHue: hue, saturation: sat, brightness: bright, alpha: 1.0)
        }
    }
}



