//
//  Observable.swift
//  FractalApp
//
//  Created by Tom Briggs on 1/7/16.
//  Copyright © 2016 Tom Briggs. All rights reserved.
//

import Foundation




enum ModelEvent {
    case RunFractal
    
}


/**
 # ModelEventListener
 
 A protocol for event-callbacks
 */
protocol ModelEventListener {
    
    func receiveEvent(generator:String, event:ModelEvent)
}



/**
 # EventManager
 
 Creates an asynchronous event listener / dispatcher queue. The code is thread-safe, and
 will dispatch events in the background using a user-initiated queue.
 
 Each event listener is identified by a `String` type.  The listener must implement the
 related `ModelEventListener` protocol to receive events.  The global `Model` is the
 only source of events (at this time).
 */
class EventManager
{
    /*
    Create a synchronous dispatch queue for imposing thread-safe operations */
    private let listenerBarrier = dispatch_queue_create("edu.ship.thb.Modelqueue",DISPATCH_QUEUE_CONCURRENT)
    
    /*
    A collection (`Dictionary`) of event listeners identified by a `String` id and
    connected to an object that implements the `ModelEventListener` protocol */
    var eventListeners = Dictionary<String, ModelEventListener>( )
    
    /**
     Adds a new listener to the dictionary.  The id will be unique - if the
     dictionary already contains the given id, then the object there will
     be replaced
     
     Parameters:
     - id: the *unique* id of the listener
     - listener: the object to receive events
     */
    func addListener(id: String, listener : ModelEventListener)
    {
        // sync up on the listener barrier - imposes a sequential ordering on
        // the event dictionary operations
        dispatch_sync(listenerBarrier) {
            self.eventListeners[id] = listener
        }
    }
    
    /**
     Removes a listener from the dictionary.  The listener associated for a given
     *id* will be removed.  This is thread-safe, so it is safe to issue a remove
     a listener even while another operation is pending.
     Parameter id: The *unique* id of the listener
     */
    func removeListener(id: String)
    {
        dispatch_sync(listenerBarrier) {
            self.eventListeners.removeValueForKey(id)
        }
    }
    
    /**
     Removes all listeners from the event queue.
     */
    func clearListeners( )
    {
        dispatch_sync(listenerBarrier) {
            self.eventListeners.removeAll()
        }
    }
    
    
    /**
     Dispatch an event to all listeners in a thread-safe manner
     Parameters:
     - generator: The name of the event generator
     - event: The `ModelEvent` to be sent
     */
    func dispatchEvent(generator:String, event:ModelEvent)
    {
        dispatch_sync(listenerBarrier) {
            for listener in self.eventListeners {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { // 1
                    listener.1.receiveEvent(generator, event: event)
                }
            }
        }
    }
}


var listeners = EventManager( )
