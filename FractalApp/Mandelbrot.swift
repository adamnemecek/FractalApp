/**
 Mandelbrot Calculation
 ======================
 
 This class manages calculation of the Mandelbrot set for use in the Fractal Viewer application.
 The implementation uses GCD to dispatch calculation threads in parallel.
 - author: Tom Briggs
 - date: 12/28/15
 - copyright:© 2015 Tom Briggs. All rights reserved.
*/
 
import Foundation
import Cocoa
import EventKit

class Mandelbrot {
    
    static let defaultRange = NSRect(x: -2, y: -1.5, width: 2.5, height: 3)

    // the default, global model
    let model = ModelFactory.getModel()
    
    // queues used for GCD dispatch
    let queueAsync = dispatch_queue_create("edu.ship.thb.Mandelbrot", DISPATCH_QUEUE_CONCURRENT)
    
    // a queue group is used to detect when the whole group has finished
    let queueGroup = dispatch_group_create()
    
    
    deinit {
        Swift.print("Mandelbrot deiniting")
    }
    
    /**
        Launch the Mandelbrot calculation using all CPUs in the system. 
      */
    func run( )
    {
        // the size of the calculation is the number of CPUs
        let size = NSProcessInfo.processInfo().processorCount
        
        // scatter the job across all CPU's
        for p in 0 ..< size
        {
            // group dispatch - effectively called "dispatch_group_enter" at the beginning of each thread
            // and "dispatch_group_exit" at the end.  Uses Swift's "closure" to launch the task
            dispatch_group_async(queueGroup, queueAsync,
                { self.calculateTask(pid: p, size: size)
                })
        }
        
        // wait for all queues to finish
        dispatch_group_wait(queueGroup, DISPATCH_TIME_FOREVER)
        
        // report job all done
        model.makeProgress(FractalProgress.init(progress: 100.0, lastLine: Int(model.getWindowSize().height)));
        
        model.recordRunState(state: RunState.init(state: RunState.Name.FINISHED))
        Swift.print("Mandelbrot finished")

    }
    
    /**
        The actual worker task, calculating the Mandelbrot computation for an interleaved field.
        With `size` workers, and this worker assigned `pid`, where `pid` in 0..<size, then this
        worker will compute rows pid, pid+size, pid+2size, pid+3size, ... pid+nsize

        - parameter pid: the process ID of the worker (0..< size)
        - parameter size: the total number of workers
    */
    private func calculateTask(pid pid:Int, size:Int)
    {
    
        let numPixelsY = Int(model.getWindowSize().height)
        let numPixelsX = Int(model.getWindowSize().width)
        
        let virtWidth = (model.getFractalRange().width)
        let virtHeight = (model.getFractalRange().height)
        
        let stepY = Double(virtHeight) / Double(model.getWindowSize().height)
        let stepX = Double(virtWidth) / Double(model.getWindowSize().width)
        
        var colorBuff = [NSColor](count: numPixelsX, repeatedValue: NSColor.clearColor())
        
        // only worker 0 is responsible for reporting progress made
        var lastPercent : Double = 0.0
        if (pid == 0) {
            model.makeProgress(FractalProgress.init(progress: 0.0, lastLine: 0))
        }
        
        // iterate over the rows of buffer
        for var y = pid; y < numPixelsY; y+=size
        {
            let vy = Double(model.getFractalRange().minY) + (stepY * Double(y))
            var vx = Double(model.getFractalRange().minX)

            // compute 1 row
            for var x = 0; x < numPixelsX; x++
            {
                let escTime = calcMandPoint(vx, y:vy)
                colorBuff[x] = ColorMap.mapColor(escTime)

                vx += stepX;
            }
            
            // this is now thread-safe
            model.setPixel(colorBuff: colorBuff, y: y)
            
            // pid 0 shall update the model's progress meter
            if (pid == 0) {
                let dy = Double(y) / Double(numPixelsY);
                let pcnt = dy * 100.0;
                if ((pcnt - lastPercent) > 10.0) {
                    model.makeProgress(FractalProgress.init(progress: pcnt, lastLine: y));
                    lastPercent = pcnt
                }
            }
        }
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



