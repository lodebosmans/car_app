var World = {
    loaded: false,
    
    init: function initFn() {
        this.createOverlays("Nesquick");
        this.createOverlays("leo");
    },

    createOverlays: function createOverlaysFn(targetname) {
        // Use christmas.wto to recognize the chirstmas figures
        this.targetCollectionResource = new AR.TargetCollectionResource("assets/" + targetname + ".wto", {
            onError: World.onError
        });

        // two figures to recognize max (in this case)
        this.tracker = new AR.ObjectTracker(this.targetCollectionResource, {
            maximumNumberOfConcurrentlyTrackableTargets: 2,
            onError: World.onError
        });

        // **  car Animation ** //
        // ********************* //
        // Read the sprite sheet
        var imgCar = new AR.ImageResource("assets/car.png", {
            onError: World.onError
        });
        // 1.0 is the height of Gingy, start with 1 and experiment with value until the figure has the right size
        // 500 (width), 500 (height) of one frame 
        var overlayCar = new AR.AnimatedImageDrawable(imgCar, 1.0, 600, 600, {
            // Use x and y to position the figure on the target object (start with 0,0 and experiment)
            // You may also need to rotate about one of the three axes, but wait and see how the figure appears. 
            // If you must rotate, do so before you begin the translation, because rotating the figure also 
            // rotates the axes.
            translate: {
                x: 0.00,
                y: 0.0
            }
            /* no rotation needed for Gingy
            ,
            rotate: {
                x: 90,
                z: 170
            }
            */
        });

        // Push the correct number of frames into a frames array
        framesCar = [];
        for (i = 0; i< 8; i++) {
            framesCar.push(i);
        }
        // Play those frames, with a pause of 80 (milliseconds?), repeat (-1)
        overlayCar.animate(framesCar, 200, -1);


        // Show Gingy when "boom" (name of the target object in the .wto file) is recognized
        this.pageCar = new AR.ObjectTrackable(this.tracker, targetname, {
            drawables: {
                cam: [overlayCar]
            },
            // onImageRecognized: World.hideInfoBar,
            onObjectRecognized: function(){
                // alert(target.name);
                // print('Target name = ')
                // print(target.name);
                AR.platform.sendJSONObject({
                    "object_scanned" : targetname
                });
            },
            onError: World.onError
        });       
    },

    // createOverlays: function createOverlaysFn() {
    //     // Use christmas.wto to recognize the chirstmas figures
    //     this.targetCollectionResource = new AR.TargetCollectionResource("assets/Nesquick.wto", {
    //         onError: World.onError
    //     });

    //     // two figures to recognize max (in this case)
    //     this.tracker = new AR.ObjectTracker(this.targetCollectionResource, {
    //         maximumNumberOfConcurrentlyTrackableTargets: 2,
    //         onError: World.onError
    //     });

    //     // **  car Animation ** //
    //     // ********************* //
    //     // Read the sprite sheet
    //     var imgCar = new AR.ImageResource("assets/car.png", {
    //         onError: World.onError
    //     });
    //     // 1.0 is the height of Gingy, start with 1 and experiment with value until the figure has the right size
    //     // 500 (width), 500 (height) of one frame 
    //     var overlayCar = new AR.AnimatedImageDrawable(imgCar, 1.0, 600, 600, {
    //         // Use x and y to position the figure on the target object (start with 0,0 and experiment)
    //         // You may also need to rotate about one of the three axes, but wait and see how the figure appears. 
    //         // If you must rotate, do so before you begin the translation, because rotating the figure also 
    //         // rotates the axes.
    //         translate: {
    //             x: 0.00,
    //             y: 0.0
    //         }
    //         /* no rotation needed for Gingy
    //         ,
    //         rotate: {
    //             x: 90,
    //             z: 170
    //         }
    //         */
    //     });

    //     // Push the correct number of frames into a frames array
    //     framesCar = [];
    //     for (i = 0; i< 8; i++) {
    //         framesCar.push(i);
    //     }
    //     // Play those frames, with a pause of 80 (milliseconds?), repeat (-1)
    //     overlayCar.animate(framesCar, 200, -1);


    //     // Show Gingy when "boom" (name of the target object in the .wto file) is recognized
    //     this.pageCar = new AR.ObjectTrackable(this.tracker, "*", {
    //         drawables: {
    //             cam: [overlayCar]
    //         },
    //         // onImageRecognized: World.hideInfoBar,
    //         onObjectRecognized: function(){
    //             // alert(target.name);
    //             // print('Target name = ')
    //             // print(target.name);
    //             AR.platform.sendJSONObject({
    //                 "object_scanned" : "Ferarri"
    //             });
    //         },
    //         onError: World.onError
    //     });       
    // },
   

    onError: function onErrorFn(error) {
        alert(error);
    },

    hideInfoBar: function hideInfoBarFn() {
    },

    showInfoBar: function worldLoadedFn() {
    },

};

World.init();