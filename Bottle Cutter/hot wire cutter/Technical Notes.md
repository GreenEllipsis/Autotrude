Software
==========
Using Marlin https://github.com/marlin-fl-ex/Makaira/tree/howWireCutter
- Build in VSCode/Auto Build Marlin
- Flash over USB (using avrdude in VSCode)

Hardware
============
With CREALITY RAMPS V2.5.2 and RepRapDiscount Full Graphic Controller.

Wire Cutter
==============
Tried 30 gauge wire with MAX_PID at 20 out of 255 and fused wire after < 10 s.
Tried MAX_PID 2 of 255 and still fused it (@24 V). On benchtop power supply, at ~2 A current/220 C, voltage was only ~2.2 V.

Next Steps
===========
- Rotary direction needs reversed in marlin-fl-ex/Makaira/tree/howWireCutter
- Need better power conditioning.

♳♳♳♳