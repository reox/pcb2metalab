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

If you create a outline, the best way is to use the Polygon function. Make sure
you use a `fullpoly`! Change this in your `.pcb` file.
A sample Outline layer can look like this:
```
Layer(7 "outline")
(
	Polygon("fullpoly")
	(
		[91000 176000] [123000 176000] [123000 225000] [259000 225000] [259000 176000] 
		[285000 176000] [285000 283000] [259000 283000] [259000 257000] [188000 257000] 
		[188000 283000] [91000 283000] 
	)
)
```

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


KiCAD
-----

This script seems to work also with KiCAD (pcbnew), but only using pcb2gcode
1.3.2 (or at least newer than 1.1.2).
KiCAD does not have a cmdline interface (there is a python interface though),
but exporting from the GUI works as well.
You need to export `F.Cu`, `B.Cu` and `Edge.Cuts`.
Then go to the Drill export and use `HPGL` as format. Export as Metric!

Then use such a `millproject` file:

```
metric=yes
zwork=-0.030
zsafe=2
mill-feed=1000
mill-speed=20000
offset=0.3
extra-passes=0
cutter-diameter=0.5
zcut=-1.65
cut-feed=1000
cut-speed=20000
cut-infeed=0.2
zdrill=-1.65
zchange=2
drill-feed=300
drill-speed=20000
milldrill=1
```

and call pcb2gcode:
```
pcb2gcode --front proj-F.Cu.gbr --back proj-B.Cu.gbr --outline proj-Edge.Cuts.gbr --drill proj.drl
```

On a double sided board, pcb2gcode will give you such an output:
```
Importing front side... DONE.
Importing back side... DONE.
Importing outline... DONE.
Processing input files... DONE.
Exporting back... DONE. (Height: 2.13156in Width: 1.88156in)
Exporting front... DONE. (Height: 2.13156in Width: 1.88156in)
Exporting outline... DONE. (Height: 2.13156in Width: 1.88156in) The board should be cut from the FRONT side.
Importing drill... DONE.
Exporting drill... DONE. The board should be drilled from the FRONT side.
END.
```

The newer versions also give you hints how to fabricate the board, in this case
you should drill from the front and also cut the outline from the front.
