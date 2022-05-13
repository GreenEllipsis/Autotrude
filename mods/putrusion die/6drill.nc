(6drill)
(Machine)
(  vendor: Nikodem Bartnik)
(  model: Generic 3-axis Router)
(  description: This machine has XYZ axis on the Head)
(T34  D=6 CR=0 TAPER=118deg - ZMIN=-27.203 - drill)
G90 G94
G17
G21

(Drill5)
T34
S560 M3
G54
G0 X0 Y-7
Z5.1
Z5
Z0.1
G1 Z-27.203 F2
G0 Z5
Z5.1
M5
M30
