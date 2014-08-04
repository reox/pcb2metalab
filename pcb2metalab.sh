#!/bin/bash
# adopted from b.kubicek's metaboard.sh script

##########################CONFIGURATION########################
pcb2gcode=/usr/bin/pcb2gcode

# get the scripts directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# some pcb2gcode versions need a preamble and postamble file, please check if these files work for you
# in the 1.1.4 version only the drillfile needs this!
preamble=$DIR/preamble.ngc
postamble=$DIR/postamble.ngc

# the diameter of the millhead in mm
millhead="0.5"

# a higher offset generates less cuts, less offset generates an "exact" image of
# the pcb. minimum should be $millhead
offset=$millhead

# choose some mm more than your pcb has. normal pcbs has 1.6mm
pcb_thickness=1.7

# tested 250mm/min cuting and milling, which seems quite good with a 0.5mm
# millhead.
# you should not go higher because the 0.5mm mill will break!

# feedrates mm per minute
feedrate=250

# how many mm we should cat in one z change.
# used when cuting and drilling.
infeed=`awk "BEGIN {print 0.4*$millhead;}"`

# speed 22000rpm should be fine
speed=22000

# height to move around
safe=10

#################################################################

PCB=$1
brdname=$(basename $PCB .pcb)



OPTS=""
OPTS+="--back ${brdname}.bottom.gbr "
OPTS+="--top ${brdname}.bottom.gbr "
OPTS+="--outline ${brdname}.outline.gbr "
OPTS+="--drill ${brdname}.plated-drill.cnc "

OPTS+="--metric --milldrill  "
OPTS+="--zwork 0 --zsafe $safe --zchange 10 --zcut -$pcb_thickness --cutter-diameter $millhead "
OPTS+="--zdrill -$infeed --drill-feed $feedrate --drill-speed $speed "
OPTS+="--offset $offset "
OPTS+="--mill-feed $feedrate --mill-speed $speed --cut-feed $feedrate --cut-speed $speed --cut-infeed $infeed "
OPTS+="--dpi 1200 "
OPTS+="--basename $brdname "
OPTS+="--preamble $preamble --postamble $postamble "


echo $pcb2gcode $OPTS 
$pcb2gcode $OPTS
