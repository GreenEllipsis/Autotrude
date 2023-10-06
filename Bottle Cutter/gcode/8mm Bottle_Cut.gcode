M92 Z1600
M201 Z100
M203 Z1000 ; faster cuts
M211 S0 ; Software Endstops Off
M113 S0 ; disable host keepalive
M106 P1 S0 ; Retract Actuator
M154 S10 ; report position every 10 s
M92 Y177.8 ; Y steps 
G28 Z; home z
G92 E0 X0 Y0 Z0
G91 ; RELATIVE MODE
M117 Cutting bottom
M118 Cutting bottom
M106 P1 S255 ; Activates Fan (Actuator)
G4 S0.5 ; Delay Seconds
G1 Y3 F1000
M106 P1 S0
G4 S0.5 ; Delay Seconds
G1 Y-3 
M400
M106 P1 S255
G4 S0.5 ; Delay Seconds
G1 Y3 F1000
M400
M106 P1 S0
G4 S0.5 ; Delay Seconds
G1 Y-3 
M400
M106 P1 S255
G4 S0.5 ; Delay Seconds
G1 F1000 Y730 ; Two+ Rotations of Bottle. Second one for manual assist, mostly
M400 ; Wait till commands complete
M114
M106 P1 S0 ; Deactivates Fan (Actuator)
G4 S0.5 ; Delay Seconds
G1 F1000 Y10
M106 P1 S255
G4 S0.5 ; Delay Seconds
G1 F1000 Y10
M106 P1 S0
M300 S100 P1000 V1 ; Alert User Through Beep
M117 Remove bottom
;M25 ; Pause print
G4 S10; Wait 10 s
M117 Moving to cut
M118 Moving to cut
M114
G1 F600 Z85 ; Move Down to stripping blade
M400 ; Wait till commands complete
M117 Cutting strips
M118 Cutting strips
M114
G1 F1000 Z150 Y6750 ; Cuts Strip 
M400 ; Wait till commands complete
M117 Cutting top
M118 Cutting top
M114
G1 F1000 Y365 ; Rotates Bottle to cut off top
G1 F1000 Y5 ; back off to make sure blade is clear
M400
M117 Homing
M118 Homing
G90
G1 Z5 F600
G91
G28 Z ; Move Z back to start
M400 ; Wait till commands complete
M117 Done. Remove top
M118 Done. Remove top
G1 F600 Y-60
G1 F3000 Y-720
;M300 S300 P1000 V0.5 ; Alert User Through Beep


