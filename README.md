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
