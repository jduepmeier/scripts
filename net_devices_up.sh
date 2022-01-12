#!/bin/bash
# shows all network devices which has the state UP
#############

ip link show | grep "state UP" | cut -d : -f 2 | cut -d " " -f 2
