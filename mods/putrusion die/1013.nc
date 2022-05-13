(1013)
(Machine)
(  vendor: Nikodem Bartnik)
(  model: Generic 3-axis Router)
(  description: This machine has XYZ axis on the Head)
(T1  D=2 CR=0 - ZMIN=-7.9 - flat end mill)
G90 G94
G17
G21

(Drill2)
T1
S5000 M3
G54
G0 X0 Y3.5
Z15
Z5
Z0.1
Z-2.9
G1 Z-6.9 F10
G0 Z0.1
Z-4.9
G1 Z-7.9 F10
G0 Z5
Z15
M5
M30
