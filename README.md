pcb2metalab
===========

some scripts to convert .pcb files to .ngc files ready for milling in the metalab's CNC

Please make sure you check all values of the generated .ngc because sometimes things get really really wrong!!!
In PCB make sure to have all signals on group 2 and outline on group 3.

In my setup i use:

* component: layer 1
* outline: layer 3
* component side: layer 1
* everything else: layer 2

Move `Makefile.sample` to your project as `Makefile`, adopt the target pcb name and then call
`make`.
Make sure `pcb2metalab.sh` is in your `$PATH`.

Some remarks to pcb2gcode:
--------------------------

* It will cut on z=0, so you have to adjust the z touchoff
  on your own! (like z=+0.035)
* Only the drillfile uses the preamble/postamble! 
  the other files will generate their own.
  Because of this you have to manually start the spindle 
  before drilling and milling!!!
* We cut, mill and drill with the same millhead.
  This is fine as long as we use a very small one. 0.5 or 0.6
  mm are very good. 0.3mm are better for milling but they are
  too short to mill through the whole pcb.
* It seems that the touchoff of the size is quite difficult now.
  While you run pcb2gcode note the size of the board. 
  These values will be the right upper corner.
  Otherwise you can touch of at 0 / 0, which will be
  the left lower corner.
