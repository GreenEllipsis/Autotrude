(1022drill3mm)
(Machine)
(  vendor: Nikodem Bartnik)
(  model: Generic 3-axis Router)
(  description: This machine has XYZ axis on the Head)
(T1  D=3 CR=0 TAPER=118deg - ZMIN=-2.901 - drill)
G90 G94
G17
G21

(Drill1)
T1
S5000 M3
G54
G0 X21 Y16.5
Z19
Z14
Z10.6
G1 Z-2.901 F50
G0 Z14
X5
Z10.6
G1 Z-2.901 F50
G0 Z14
Y4.5
Z10.6
G1 Z-2.901 F50
G0 Z14
Z19
M5
M30
