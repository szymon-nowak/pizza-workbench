
// pizzaWorkbench 1.0.0


$fn = 50; // number of fragments (special scad variable)

// all dimensions in mm - millimeters 

boardHeight = 19;
boardDepth  = 620;

countertopWidth = 1100;
countertopDepth = 415;

drawerHeight = 160;

containers = // [ containerWidth, containerX ]
[
    [ 162, 0   ],
    [ 162, 162 ],
    [ 162, 324 ],
    [ 162, 486 ],
    [ 108, 648 ],
    [ 325, 756 ],
];

// colors
transparency = 1.0;
cSteel = [ 0.9, 0.9, 0.9, transparency ]; // stainless steel
cBeech = [ 0.96, 0.87, 0.68, transparency ]; // beech wood
cWhite = [ 0.99, 0.99, 0.99, transparency ];
cRed   = [ 1.0, 0.0, 0.0, transparency ];

workbenchWidth = countertopWidth;
workbenchDepth = boardDepth + boardHeight;


translate([ -workbenchWidth/2, -workbenchDepth/2, -boardHeight ]) {

    // 300mm (~12 inches) pizza
    color( cRed ) translate([ countertopWidth/2, countertopDepth/2, boardHeight ]) cylinder( h = 10, d = 300, center = false );

    // workspace (top)
    color( cBeech ) cube([ countertopWidth, boardDepth, boardHeight ]);

    // base (bottom)
    baseDepth = boardDepth - boardHeight - 1;
    color( cBeech ) translate([ 0, boardHeight + 1, -drawerHeight ]) cube([ countertopWidth, baseDepth, boardHeight ]);

    // back
    backHeight = 310;
    color( cBeech ) translate([ 0, workbenchDepth - boardHeight, -drawerHeight ]) cube([ workbenchWidth, boardHeight, backHeight ]);

    // leftSide
    leftSidePoints = [
        [  0,  0,  0 ],
        [ boardHeight,  0,  0 ],
        [ boardHeight,  workbenchDepth,  0 ],
        [  0,  workbenchDepth,  0 ],
        [  0,  0,  drawerHeight + boardHeight ],
        [ boardHeight,  0,  drawerHeight + boardHeight ],
        [ boardHeight,  workbenchDepth,  backHeight ],
        [  0,  workbenchDepth,  backHeight ]];
    leftSideFaces = [ [0,1,2,3], [4,5,1,0], [7,6,5,4], [5,6,2,1], [6,7,3,2], [7,4,0,3] ];
    color( cBeech, 0.9 ) translate([ -boardHeight, 0, -drawerHeight ]) polyhedron( leftSidePoints, leftSideFaces );

    // containers front
    color( cBeech ) translate([ 0, countertopDepth, boardHeight ]) cube([ workbenchWidth, boardHeight, 100 ]);

    // containers
    for ( container = containers ) {
        translate([ container[1], countertopDepth + 35, boardHeight + 25 ]) rotate([ 10, 0, 0 ]) GNContainer( container[0], cSteel );
    }
    
    // right drawer (for dough tray)
    drawerInsideWidth = 600;
    drawerInsideDepth = 500;
    drawerSideSpace = 45;
    drawerFrontWidth = drawerInsideWidth + 2 * drawerSideSpace;
    drawerBaseBottom = 9;
    drawerBaseTop = drawerBaseBottom + 16;
    translate([ workbenchWidth/2 - ( drawerFrontWidth - workbenchWidth/2 ), -200, -drawerHeight ]) {
        
        // right drawer front
        color( cBeech ) translate([ 0, 0, 0 ]) cube([ drawerFrontWidth, boardHeight, drawerHeight ]);
        
        // right drawer base (bottom)
        color( cBeech ) translate([ drawerSideSpace, boardHeight, boardHeight + drawerBaseBottom ]) cube([ drawerInsideWidth, drawerInsideDepth, 83 ]);
  
        // dough tray 60x40x10cm
        drawerLevel = 25;
        color( cWhite ) translate([ drawerSideSpace, 35, boardHeight + drawerLevel ]) cube([ 600, 400, 100 ]);

    }
     
    // left drawer
    drawer2InsideWidth = 318;
    drawer2InsideDepth = 550;
    drawer2SideSpace = 45;
    drawer2FrontWidth = drawer2InsideWidth + 2 * drawer2SideSpace;
    drawer2BaseBottom = 9;
    drawer2BaseTop = drawer2BaseBottom + 16;

    translate([ 0, -100, -drawerHeight ]) {
        
        // left drawer front
        color( cBeech ) translate([ 0, 0, 0 ]) cube([ drawer2FrontWidth, boardHeight, drawerHeight ]);
        
        // left drawer base (bottom)
        color( cBeech ) translate([ drawer2SideSpace, boardHeight, boardHeight + drawer2BaseBottom ]) cube([ drawer2InsideWidth, drawer2InsideDepth, 83 ]);

    }
 
    // separator (between drawers)
    color( cBeech ) translate([ drawer2FrontWidth - boardHeight, boardHeight - 0, -drawerHeight+boardHeight ]) cube([ boardHeight, baseDepth, drawerHeight-boardHeight ]);
  
    // drainage
    color( cSteel ) translate([ workbenchWidth/2 + boardHeight + 20, workbenchDepth - boardHeight - 45, -170]) cylinder( h = 200, d = 50, center = false );

}


// Gastronorm container module
module GNContainer( width = 108, color ) {

    height = 65;
    depth = 176;
    topHeight = 5;
    topRadius = 10;
    topGap = 10;

    difference() {
        union() {
            
            // top
            translate([ topRadius, topRadius, height - topHeight ]) color( color ) minkowski() {
                cube([ width - topRadius*2, depth - topRadius*2, topHeight/2 ]);
                cylinder( r=topRadius, h=topHeight/2 );
            }

            // bottom
            translate([ topGap, topGap, 0 ]) color( color ) cube([ width - 2*topGap, depth - 2*topGap, height ]);

        }

        translate([ topGap+2, topGap+2, 2 ]) color( color ) cube([ width - 2*topGap-4, depth - 2*topGap-4, height+4 ]);

    }

}