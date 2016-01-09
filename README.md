# FractalApp
This is an early attempt at working with XCode, Cocoa, and Swift.  The application is "simple" fractal generator/viewer.  

The code makes exensive use of Swift features, especially a well-designed class hierarchy, classic design patterns including:
* observer/observable
* singleton
* synch/async dispatch
* delegation

The UI uses mouse click/drag events to pan around the display, as well as handles trackpad gestures for pinch zoom on the image.  It also uses the scroll-wheel for view.

The code makes heavy use of multi-threading using Grand Central Dispatch.  

The TODO list includes:
* implementing more fractal types
* OpenCL and/or Metal for GPU off-loading
* activate and handle the menu bar (esp):
** Undo
** File -> Save As ..
