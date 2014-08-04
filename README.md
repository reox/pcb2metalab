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

Sample
------

A sample output will look like this:

```
$ make
pcb -x gerber my_pcb.pcb
pcb2metalab.sh my_pcb.pcb
/usr/bin/pcb2gcode --back my_pcb.bottom.gbr --front my_pcb.top.gbr
--outline my_pcb.outline.gbr --drill my_pcb.plated-drill.cnc --metric
--milldrill --zwork 0 --zsafe 10 --zchange 10 --zcut -1.7 --cutter-diameter 0.5
--zdrill -0.2 --drill-feed 250 --drill-speed 22000 --offset 0.5 --mill-feed 250
--mill-speed 22000 --cut-feed 250 --cut-speed 22000 --cut-infeed 0.2 --dpi 1200
--basename my_pcb --preamble
/home/reox/data/git/elektronik/pcb2metalab/preamble.ngc --postamble
/home/reox/data/git/elektronik/pcb2metalab/postamble.ngc
Importing front side... done
Importing back side... done
Importing outline... done
clearing
clearing
clearing
Calculated board dimensions: 3.02978in x 1.25979in
Current Layer: back, exporting to my_pcb_back.ngc.
Current Layer: front, exporting to my_pcb_front.ngc.
Current Layer: outline, exporting to my_pcb_outline.ngc.
Converting my_pcb.plated-drill.cnc... Currently Drilling 
done.
```

You can use the size that is printed out for the touch off.
