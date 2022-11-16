var World = {
    loaded: false,
    
    init: function initFn() {
        // parameters for the overlay
        // - carname
        // - number of frames
        // - width
        // - height
        // - scale factor x direction
        // - scale factor y direction
        this.createOverlays("audi", 30, 230, 139, 1, 1); 
        this.createOverlays("volkswagen", 45, 150, 150, 3, 3); 
        this.createOverlays("ferarri", 30, 197, 259, 2, 2); 
        this.createOverlays("lamborghini", 24, 200, 173, 2, 2); 
        this.createOverlays("tesla", 30, 204, 276, 2, 2); 
        this.createOverlays("traktor", 10, 150, 112, 1.5, 1.5); 
    },

    createOverlays: function createOverlaysFn(targetname, nrOfFrames, width, height, scaleX, scaleY) {
        // Use the wto files to recognize the objects
        this.targetCollectionResource = new AR.TargetCollectionResource("assets/" + targetname + ".wto", {
            onError: World.onError
        });

        // two figures to recognize max (in this case)
        this.tracker = new AR.ObjectTracker(this.targetCollectionResource, {
            maximumNumberOfConcurrentlyTrackableTargets: 2,
            onError: World.onError
        });

        // Read the sprite sheet
        var imgCar = new AR.ImageResource("assets/" + targetname + ".png", {
            onError: World.onError
        });
        // 1.0 is the height, start with 1 and experiment with value until the figure has the right size
        // 500 (width), 500 (height) of one frame 
        var overlayCar = new AR.AnimatedImageDrawable(imgCar, 1.0, width, height, {
            // Use x and y to position the figure on the target object (start with 0,0 and experiment)
            // You may also need to rotate about one of the three axes, but wait and see how the figure appears. 
            // If you must rotate, do so before you begin the translation, because rotating the figure also 
            // rotates the axes.
            translate: {
                x: 0.00,
                y: 0.0
            },
            /* ,
            rotate: {
                x: 90,
                z: 170
            }
            */
            scale: {
                x: scaleX,
                y: scaleY
            }
            
        });

        // Push the correct number of frames into a frames array
        framesCar = [];
        for (i = 0; i< nrOfFrames; i++) {
            framesCar.push(i);
        }
        // Play those frames, with a pause of 100 (milliseconds?), repeat (-1)
        overlayCar.animate(framesCar, 100, -1);


        // Show the car sprite when the correspronding object is recognized
        this.pageCar = new AR.ObjectTrackable(this.tracker, targetname, {
            drawables: {
                cam: [overlayCar]
            },
            onObjectRecognized: function(){
                AR.platform.sendJSONObject({
                    "object_scanned" : targetname
                });
            },
            onError: World.onError
        });       
    },

    onError: function onErrorFn(error) {
        alert(error);
    },

    hideInfoBar: function hideInfoBarFn() {
    },

    showInfoBar: function worldLoadedFn() {
    },

};

World.init();