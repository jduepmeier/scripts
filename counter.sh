#!/bin/bash
###########
# counts execution and
# runs a command if maxcount
# is reached.
# #########

CMD="echo reached"
MEM=.mem.sh
MAXCOUNTER=5
# maximal tolerance time between the executions
TOLERANCE=30
RESETTIME=500
CURRENT=$(date +%s)

echo "$CURRENT"

if [ -a $MEM ]
then
	source $MEM
else
	MEMTIME=0
	MEMCOUNTER=0
fi

MEMTIME=$(($MEMTIME + $TOLERANCE))
echo "$MEMTIME"

if [ "$MEMTIME" -ge "$CURRENT" ]
then
	if [ "$MEMCOUNTER" -gt "$MAXCOUNTER" ]
	then
		$CMD
		MEMCOUNTER=0
	else
		MEMCOUNTER=$(($MEMCOUNTER + 1))
	fi
fi
MEMTIME=$(($MEMTIME - $TOLERANCE + $RESETTIME))

if [ "$MEMTIME" -lt "$CURRENT" ]
then
	MEMCOUNTER=0
fi
echo "$MEMCOUNTER"

echo "export MEMTIME=$CURRENT" > $MEM
echo "export MEMCOUNTER=$MEMCOUNTER" >> $MEM

