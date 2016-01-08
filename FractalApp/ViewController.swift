//
//  ViewController.swift
//  FractalApp
//
//  Created by Tom Briggs on 1/7/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var myBtnRun: NSButton!
    
    @IBOutlet weak var myProgressBar: NSProgressIndicator!
    
    @IBOutlet weak var myTypePopup: NSPopUpButton!
    
    @IBOutlet weak var myTxtStatus: NSTextField!

    
    @IBOutlet weak var myImageView: NSImageView!
   
    let myMagGesture = MyMagGesture( )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myImageView.image = ModelFactory.getModel().getFractalImage()
    
        if (myImageView.layer != nil) {
            Swift.print(myImageView.layer?.visibleRect)
        }

        ModelFactory.getModel().handleWindowResize(myImageView.frame.size)

        myImageView.addGestureRecognizer(myMagGesture)
        myMagGesture.parent = self;
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("progress", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "progress") && (notification.object is FractalProgress)) {
                dispatch_sync(dispatch_get_main_queue()) {
                    self.myProgressBar.doubleValue = (notification.object as! FractalProgress).progress
                    //myProgressBar.value = fp.value
                } // end dispatch
            } // end if
        })  // end block & addobserver

        
        NSNotificationCenter.defaultCenter().addObserverForName("runState", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "runState") && (notification.object is RunState)) {
                dispatch_sync(dispatch_get_main_queue()) {
                    let rs : RunState = notification.object as! RunState
                    if (rs.state == RunState.Name.FINISHED)
                    {
                        self.myBtnRun.enabled = true
                        self.myProgressBar.doubleValue = 100.0
                    }
                    
                    //myProgressBar.value = fp.value
                } // end dispatch
            } // end if
        })  // end block & addobserver
        

        
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        
        Swift.print("view bounds \(view.bounds)")
        
    }
    
    
    @IBAction func handleBtnRun(sender: AnyObject) {

        startRun( )
        
    }
    
    private func startRun( )
    {
        myBtnRun.enabled = false
        
       ModelFactory.getModel().handleWindowResize(myImageView.frame.size)
        
        myImageView.image = ModelFactory.getModel().getFractalImage()
   
        if (myTypePopup.titleOfSelectedItem == FractalType.Mandelbrot.rawValue)
        {
            let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
            let queue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(queue, {
                let M = Mandelbrot( )
                M.run( )
                self.myImageView.needsDisplay = true
            })
        }
    
    }
    
    
    
    @IBAction func handleTypeChange(sender: AnyObject) {
        
        ModelFactory.getModel().setFractalType(myTypePopup.stringValue)
        
        
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    class MyMagGesture : NSMagnificationGestureRecognizer {
        
        weak var parent : ViewController!
        
        
        override func magnifyWithEvent(event: NSEvent) {
            
            if (event.phase == NSEventPhase.Ended) {
                Swift.print("Magnify: \(event)")

//                ModelFactory.getModel().magnify(event.magnification);
//
//                if (parent != nil) {
//                    let z = ModelFactory.getModel().getZoom()
//                    let r = ModelFactory.getModel().getFractalRange()
//                    
//                    parent.myTxtStatus.stringValue = "Zoom \(z)X \(r)"
//                    
//                    parent.startRun()
//                }
            }
        }
        
    }

}

