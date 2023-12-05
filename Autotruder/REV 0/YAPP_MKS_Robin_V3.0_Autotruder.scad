//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  YAPP Version v2.1.0 (20-11-2023) plus 2 Green Ellipsis pull requests
//  23329BBA01 (base) REV 0
//  23329BBA02 (lid) REV 0
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

include <YAPPgenerator_v21.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax ---> 
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right 
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---              
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/

// Set the default preview and render quality from 1-32  
previewQuality = 5;   // Default = 5
renderQuality = 10;   // Default = 12

//-- which part(s) do you want to print?
printBaseShell        = false;
printLidShell         = true;
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 84; // Front to back
pcbWidth            = 110; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 8.5;
paddingLeft         = 8.5; //8.5;

//-- Edit these parameters for your own box dimensions
wallThickness       = 1.8;
basePlaneThickness  = 1.25;
lidPlaneThickness   = 1.25;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 10;
lidWallHeight       = 23;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 6;  //-- used only for pushButton and showPCB
standoffPinDiameter = 2.8;
standoffHoleSlack   = 0.4;
standoffDiameter    = 7;

//-- D E B U G -----------------//-> Default ---------
// false puts lid over base
showSideBySide      = false; // [false,true];   
// space between base and lid
onLidGap            = 0;
// additional distance between base and lid when side by side
shiftLid            = 5;
colorLid            = "YellowGreen";   
lidAlpha            = 1;
colorBase           = "BurlyWood";
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
inspectXfromBack    = true;    // View from the inspection cut foreward
inspectYfromLeft    = true;     // View from the inspection cut to the right
//inspectLightTubes   = 0;      //-> { -1 | 0 | 1 }
//inspectButtons      = 0;      //-> { -1 | 0 | 1 } 
//-- import a supported mesh file for your PCB
pcbFilename         = "MKS Robin Nano V3.stl";
pcbTranslation      = [pcbLength,pcbWidth,0]; 
pcbRotation         = [0,0,90]; 

//-- D E B U G ---------------------------------------

// ==================================================================
// Shapes
// ------------------------------------------------------------------

// Shapes should be defined to fit into a 2x2 box (+/-1 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [[-1,-1],[0,1],[1,-1]] 

// Pre-defined shapes
shapeIsoTriangle = [[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]];
shapeHexagon = [[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]];
shape6ptStar = [[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]];



/*==================================================================
 *** Masks ***
 ------------------------------------------------------------------
Parameters:
  maskName = [
   (0) = Grid pattern :{ yappPatternSquareGrid | yappPatternHexGrid }  
   (1) = width
   (2) = height
   (3) = thickness
   (4) = horizontal Repeat
   (5) = vertical Repeat
   (6) = grid rotation
   (7) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
   (8) = openingWidth, 
   (9) = openingLength, 
   (10) = openingRadius
   (11) = openingRotation
   (12) = shape polygon : Requires if openingShape = yappPolygon];
  ];
*/
maskHoneycomb = [
yappPatternHexGrid,    //pattern
  100,                  // width - must be over the opening size : adding extra will shift the mask within the opening
  104,                  // height
  2.1,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  30,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   //openingRotation
  shapeHexagon];


maskHexCircles = [
yappPatternHexGrid,    //pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappCircle,          // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0,                   //openingRotation
  []];

maskBars = [
  yappPatternSquareGrid, //yappPatternSquareGrid,//pattern
  110,                  // width
  110,                  // height
  5,                    // thickness - to do a full cutout make it > wall thickness
  4,                    // hRepeat
  4,                    // vRepeat
  0,                    // rotation
  yappRectangle,          // openingShape
  3,                    // openingWidth, 
  3,                    // openingLength, 
  2.5,                    // openingRadius
  0,                   //openingRotation
  []
];


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);
/*===================================================================
 *** PCB Supports ***
 Pin and Socket standoffs 
 ------------------------------------------------------------------
Default origin =  yappPCBCoord : pcb[0,0,0]

Parameters:
  (0) = posx
  (1) = posy
  (2) = additional standoffHeight
  (3) = filletRadius (0 = auto size)
  (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
  (n) = { yappHole, <yappPin> } // Baseplate support treatment
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { yappBoxCoord, <yappPCBCoord> }  
  (n) = { yappNoFillet }
*/
pcbStands = [
  [4, 4, standoffHeight, 0, yappBaseOnly, yappHole, yappAllCorners],
//  [4+76, 4, standoffHeight, 0, yappHole],
//  [4, 4+102, standoffHeight, 0, yappHole],
//  [4+76, 4+102, standoffHeight, 0, yappHole],
];


/*===================================================================
 *** Connectors ***
 Standoffs with hole through base and socket in lid for screw type connections.
 ------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]
  
Parameters:
  (0) = posx
  (1) = posy
  (2) = pcbStandHeight
  (3) = screwDiameter
  (4) = screwHeadDiameter (don't forget to add extra for the fillet)
  (5) = insertDiameter
  (6) = outsideDiameter
  (7) = filletRadius (0 = auto size)
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { <yappBoxCoord>, yappPCBCoord }
  (n) = { yappNoFillet }
  (n) = { yappThroughLid }
  
*/
// FIXME need to insert screws from top, not bottom
// TODO be able to specifiy the through-hole distance to control screw length
connectors   =
  [ 
  [wallThickness+4, wallThickness+4, -1, 3.7, 7.5, 3.7, 8, -1, 0, yappAllCorners, yappNoFillet, yappThroughLid]
  ];

/*===================================================================
*** Base Mounts ***
  Mounting tabs on the outside of the box
 ------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]

Parameters:
  (0) = pos - if vector, 2nd dimension is distance between hole center and shell wall
  (1) = screwDiameter
  (2) = width
  (3) = height
  (4) = filletRadius
  (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
  (n) = { yappNoFillet }
*/
baseMounts =
[
  [[shellWidth-5,10], 4.2, 0, 5, yappFront, yappNoFillet],
  [[shellWidth-5,(110-10-shellLength)], 5, 0, 5, yappBack, yappNoFillet],
  [[5,10], 4.2, 0, 5, yappFront, yappNoFillet],
  [[5,(110-10-shellLength)], 4.2, 0, 5, yappBack, yappNoFillet],
];


/*===================================================================
*** Cutouts ***
  There are 6 cutouts one for each surface:
    cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]

Parameters:
 (0) = from Back
 (1) = from Left
 (2) = width
 (3) = length
 (4) = radius
 (5) = depth 0=Auto (plane thickness)
 (6) = angle
 (7) = yappRectangle | yappCircle | yappPolygon | yappRoundedRect
 (8) = Polygon : [] if not used.  - Required if yappPolygon specified -
 (9) = Mask : [] if not used.  - Required if yappUseMask specified -
 (n) = { <yappBoxCoord> | yappPCBCoord }
 (n) = { <yappOrigin>, yappCenter }
 (n) = { yappUseMask }
*/

cutoutsBase = 
[
];

cutoutsLid  = 
[
  [shellLength/2,shellWidth/2 ,pcbWidth,pcbLength, 5 ,5 ,0, yappRectangle, [], maskBars, yappCenter, yappUseMask]
];

pcbX = wallThickness+paddingBack;
pcbY = wallThickness+paddingLeft; 
pcbZ = basePlaneThickness + standoffHeight + pcbThickness;

cutoutsFront =  
[
  // USB Type B
 [pcbY+21.75-0.5, pcbZ-0.5, 11+1, 12+1, 0 ,0 ,0, yappRectangle,yappOrigin],
 // USB TYpe A
 [pcbY+37.629-0.5, pcbZ-0.5, 5.72+1, 14+1, 0 ,0 ,0, yappRectangle,yappOrigin],
 // microSD
 [pcbY+47.446-0.5, pcbZ-0.5, 14.85+1, 1.8+1, 0 ,0 ,0, yappRectangle,yappOrigin],
];


cutoutsBack = 
[
];

cutoutsLeft =   
[
 [pcbX+8, pcbZ-0.5, pcbLength-8*2, lidWallHeight-2, 0 ,0 ,0, yappRectangle,yappOrigin],
];

cutoutsRight =  
[
];


/*===================================================================
*** Snap Joins ***
------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]

Parameters:
 (0) = posx | posy
 (1) = width
 (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
 (n) = { <yappOrigin> | yappCenter }
 (n) = { yappSymmetric }
*/

snapJoins   =   [
//                  [(shellWidth/2),     10, yappFront, yappCenter]
//                , [25,  10, yappBack, yappSymmetric, yappCenter]
//                , [(shellLength/2),    10, yappLeft, yappRight, yappCenter]
                ];

/*===================================================================
*** Light Tubes ***
------------------------------------------------------------------
Default origin = yappPCBCoord: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = tubeLength
 (3) = tubeWidth
 (4) = tubeWall
 (5) = gapAbovePcb
 (6) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole
 (7) = tubeType    {yappCircle|yappRectangle}
 (8) = filletRadius
 (n) = { yappBoxCoord, <yappPCBCoord> }
 (n) = { yappNoFillet }
*/

lightTubes =
[
//  [pcbLength/2,pcbWidth/2,  // Pos
//    5, 5,                   // W,L
//    1,                      // wall thickness
//    standoffHeight + pcbThickness + 4,    // Gap above base bottom
//    .5,                      // lensThickness (from 0 (open) to lidPlaneThickness)
//    yappRectangle,          // tubeType (Shape)
//    0,                      // filletRadius
//    yappPCBCoord            //
//  ]
//  ,[pcbLength/2+30,pcbWidth/2, // Pos
//    5, 5,                 // W,L
//    1,                      // wall thickness
//    12,                      // Gap above PCB
//    0,                    // lensThickness
//    yappCircle,          // tubeType (Shape)
//    0,                      // filletRadius
//    yappCenter            //
//  ]
];

/*===================================================================
*** Push Buttons ***
------------------------------------------------------------------
Default origin = yappPCBCoord: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = capLength
 (3) = capWidth
 (4) = capAboveLid
 (5) = switchHeight
 (6) = switchTrafel
 (7) = poleDiameter
 (6) = filletRadius
 (n) = buttonType  {yappCircle|yappRectangle}
*/
pushButtons = 
[
//   [15, 60, 8, 6, 2, 3.5, 1, 3.5, 0, yappCircle, yappNoFillet]
//  ,[15, 40, 8, 6, 2, 3.5, 1, 3.5, 0, yappRectangle, yappNoFillet]
];
             
/*===================================================================
*** Labels ***
------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]

Parameters:
 (0) = posx
 (1) = posy/z
 (2) = orientation
 (3) = depth
 (4) = plane {lid | base | left | right | front | back }
 (5) = font
 (6) = size
 (7) = "label text"
 */
labelsPlane =
[
    [11, 3, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ],
    [38, 2, 0, 1, "lid", "Century Gothic:style=Bold", 5, "GreenEllipsis" ],
    [7, shellWidth-8, 0, 1, "lid", "Century Gothic:style=Bold", 5, "MKS Robin Nano V3" ],
    [7, 10, 0, 1, "back", "Century Gothic:style=Bold", 7, "P/N 23329BBA02"],
    [shellWidth-49, 10, 0, 1, "base", "Century Gothic:style=Bold", 7, "P/N 23329BBA01"],
];


//===========================================================
module lidHookInside()
{
  echo("lidHookInside(original) ..");
  translate([40, 40, -8]) color("purple") cube([15,20,10]);
  
} // lidHookInside(dummy)
  
//===========================================================
module lidHookOutside()
{
  echo("lidHookOutside(original) ..");
  translate([(shellLength/2),-5,-5])
  {
    color("yellow") cube([20,15,10]);
  }  
} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
  //echo("baseHookInside(original) ..");
  echo("baseHookInside(original) ..");  
  translate([10, 30, -5]) color("lightgreen") cube([15,25,8]);
  
} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
  echo("baseHookOutside(original) ..");
  translate([shellLength-wallThickness-10, 55, -5]) color("green") cube([15,25,10]);
  
} // baseHookOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
