#!/bin/bash
# adopted from b.kubicek's metaboard.sh script

##########################CONFIGURATION########################
pcb2gcode=/usr/bin/pcb2gcode

# some pcb2gcode versions need a preamble and postamble file, please check if these files work for you
preamble=preamble.ngc
postamble=postamble.ngc

# all values are in mm
millhead="0.5"
# choose some mm more than your pcb has. normal pcbs has 1.6mm
pcb_thickness=1.8
#feedrates mm per minute
# TODO need to check if these values are correct...
drillfeedrate=250
cutfeedrate=400
millfeedrate=400
# speed 22000rpm should be fine
speed=22000
#height to move around
safe=4
offset=$millhead
#################################################################

PCB=$1
brdname=$(basename $PCB .pcb)

infeed=`awk "BEGIN {print 0.4*$millhead;}"`


OPTS=""
OPTS+="--back ${brdname}.bottom.gbr "
OPTS+="--outline ${brdname}.outline.gbr "
OPTS+="--drill ${brdname}.plated-drill.cnc "

OPTS+="--metric --milldrill  "
OPTS+="--zwork 0 --zsafe $safe --zchange 10 --zcut -$pcb_thickness --cutter-diameter $millhead "
OPTS+="--zdrill -$infeed --drill-feed $drillfeedrate --drill-speed $speed "
OPTS+="--offset $offset "
OPTS+="--mill-feed $millfeedrate --mill-speed $speed --cut-feed $cutfeedrate --cut-speed $speed --cut-infeed $infeed "
OPTS+="--dpi 1200 "
OPTS+="--basename $brdname "
OPTS+="--preamble $preamble --postamble $postamble "


echo $pcb2gcode $OPTS 
$pcb2gcode $OPTS
