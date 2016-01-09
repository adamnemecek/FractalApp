//
//  CustomImageView.swift
//  FractalApp
//
//  Created by Tom Briggs on 1/9/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import Cocoa

class CustomImageView: NSImageView {

    var parent : ViewController?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        if ((dragStart != nil) && (dragEnd != nil)) {
            let path = NSBezierPath()
            let color = NSColor.whiteColor()
            color.set()
            path.moveToPoint(dragStart!)
            path.lineToPoint(dragEnd!)
            path.lineCapStyle = NSLineCapStyle.ButtLineCapStyle
            path.lineWidth = 5.0
            path.stroke()
        }

    }
    
    
    override func scrollWheel(theEvent: NSEvent) {
        
        super.scrollWheel(theEvent)
        
        let scaleFactor = CGFloat(10.0)
        
        let zoom = (theEvent.deltaY / self.frame.size.height) * scaleFactor
        
        
        ModelFactory.getModel().magnify( zoom );
        
        if (parent != nil) {
            parent?.startRun()
        }
    }
 
    var dragStart : NSPoint?
    var dragEnd : NSPoint?
    
    override func mouseDown(theEvent: NSEvent) {
        Swift.print("Mouse down \(theEvent)")
        dragStart = self.convertPoint(theEvent.locationInWindow, fromView: nil)

    }
    
    override func mouseDragged(theEvent: NSEvent) {
        Swift.print("Mouse dragged \(theEvent)")
        dragEnd = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        needsDisplay = true
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Swift.print("Mouse up \(theEvent)")
        guard ((dragStart != nil) && (dragEnd != nil)) else { return }
        
        // difference in pixels
        let deltaX = (dragEnd!.x - dragStart!.x)
        let deltaY = (dragEnd!.y - dragStart!.y)

        // convert to percent of screen
        let fractalRect = ModelFactory.getModel().getFractalRange()

        let pcntX = 1.0 + (deltaX / frame.width)
        let pcntY = 1.0 + (deltaY / frame.height)
        
        // now, convert to fractal space
        let newOriginX = fractalRect.origin.x * pcntX
        let newOriginY = fractalRect.origin.y * pcntY

        let newRange = NSRect(x: newOriginX, y: newOriginY, width: fractalRect.width, height: fractalRect.height)
        
        ModelFactory.getModel().setFractalRange(newRange)
        
        dragStart = nil
        dragEnd = nil
        
        if (parent != nil) {
            parent?.startRun()
        }

    }
}
