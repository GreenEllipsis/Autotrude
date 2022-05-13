(1002)
(Machine)
(  vendor: Nikodem Bartnik)
(  model: Generic 3-axis Router)
(  description: This machine has XYZ axis on the Head)
(T34  D=1.7 CR=0 TAPER=118deg - ZMIN=-26.411 - drill)
G90 G94
G17
G21

(Drill1)
T34
S3000 M3
G54
G0 X0 Y-1
Z15
Z5
Z0.1
Z-2.9
G1 Z-10.9 F20
G0 Z0.1
Z-8.9
G1 Z-15.9 F20
G0 Z0.1
Z-13.9
G1 Z-19.9 F20
G0 Z0.1
Z-17.9
G1 Z-22.9 F20
G0 Z0.1
Z-20.9
G1 Z-24.9 F20
G0 Z0.1
Z-22.9
G1 Z-26.411 F20
G4 P0.25
G0 Z5
Z15
M5
M30
