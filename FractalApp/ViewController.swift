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
    
    @IBOutlet weak var myImageView: CustomImageView!
   
    let myMagGesture = MyMagGesture( )
    
    let serialQueue = dispatch_queue_create("edu.ship.thb.ViewController", DISPATCH_QUEUE_SERIAL);
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myImageView.parent = self
        myImageView.image = ModelFactory.getModel().getFractalImage()
    
        if (myImageView.layer != nil) {
            Swift.print(myImageView.layer?.visibleRect)
        }

        ModelFactory.getModel().handleWindowResize(myImageView.frame.size)

        myMagGesture.parent = self;
        myImageView.addGestureRecognizer(myMagGesture)
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("progress", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "progress") && (notification.object is FractalProgress)) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.myProgressBar.doubleValue = (notification.object as! FractalProgress).progress
                    self.myImageView.needsDisplay = true
                    //myProgressBar.value = fp.value
                } // end dispatch
            } // end if
        })  // end block & addobserver

        
        NSNotificationCenter.defaultCenter().addObserverForName("runState", object: nil, queue: nil, usingBlock: { notification in
            
            if ((notification.name == "runState") && (notification.object is RunState)) {
                dispatch_async(dispatch_get_main_queue()) {
                    let rs : RunState = notification.object as! RunState
                    if (rs.state == RunState.Name.FINISHED)
                    {
                        self.myBtnRun.enabled = true
                        self.myProgressBar.doubleValue = 100.0
                        self.myImageView.needsDisplay = true
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
    
    
    private func startMandelbrot( ) {
        let M = Mandelbrot( )
        M.run( )

        self.myTxtStatus.stringValue =
            String(format: "Zoom: %0.3fx Region:(%0.3g,%0.3g)->(%0.3g,%0.3g)",
                1.0/ModelFactory.getModel().getZoom(),
                ModelFactory.getModel().getFractalRange().origin.x,
                ModelFactory.getModel().getFractalRange().origin.y,
                ModelFactory.getModel().getFractalRange().maxX,
                ModelFactory.getModel().getFractalRange().maxY)
    }
    
    func startRun( )
    {
        
        dispatch_sync(serialQueue, {

            self.myBtnRun.enabled = false
            
            ModelFactory.getModel().handleWindowResize(self.myImageView.frame.size)
            
            self.myImageView.image = ModelFactory.getModel().getFractalImage()
       
            if (self.myTypePopup.titleOfSelectedItem == FractalType.Mandelbrot.rawValue)
            {
                dispatch_async(self.serialQueue, {
                    self.startMandelbrot()
                })
            }
        })
    
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

            ModelFactory.getModel().magnify(event.magnification);

            if (event.phase == NSEventPhase.Ended) {
                Swift.print("Magnify: \(event)")

                if (parent != nil) {
                    parent.startRun()
                }
            }
        }
        
    }
    

}

