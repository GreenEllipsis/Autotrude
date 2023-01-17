;Experimental G-code to force Marlin to slow down its parser. 
; See paragraph 5. Command Blocking at https://marlinfw.org/docs/development/code_structure.html
M117 Warming up
M109 S210
M117 RECREATING FILAMENT
G1 E0 F300 ;set default feed rate
M83  ; extruder relative mode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
G4 S10 ; wait before reading next gcode
G1 E30 ; extrude 30 mm (about 10 s)
; and so on
