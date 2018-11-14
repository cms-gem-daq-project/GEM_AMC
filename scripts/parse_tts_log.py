#!/usr/bin/env python

from utils import *
import signal
import sys
import os
import struct

def main():

    logfile = ''

    if len(sys.argv) < 2:
        print('Usage: parse_tts_log.py <tcds_tts_logfile>')
        return
    else:
        logfile = sys.argv[1]

    if not os.path.exists(logfile):
        print "Input file %s does not exist." % logfile
        return

    f = open(logfile, 'r')

    numSeparators = 0
    while numSeparators < 4:
        line = f.readline()
        if ("-------------------------------" in line):
            numSeparators += 1

    print "Found the start of the log"

    numWarn = 0
    numBusy = 0
    numOos = 0
    numErr = 0
    numOther = 0

    for line in f:
        if ("-------------------------------" in line):
            break;

        fields = line.split()
        timestamp = fields[0]
        orbit = int(fields[1])
        bx = int(fields[2])
        state = fields[3]

        # software comment
        if (orbit == 0 and bx == 0 and "LM_00" in state):
            continue

        stateNum = int(state[3:], 16)

        if (stateNum == 8):
            continue
        elif (stateNum == 4):
            numBusy += 1
        elif (stateNum == 1):
            numWarn += 1
        elif (stateNum == 2):
            numOos += 1
        elif (stateNum == 12):
            numErr += 1
        else:
            numOther += 1
            print "Unknown transition found: %s" % line

    print "----------------------------------------------------"
    print "Total WARN Transitions: %d" % numWarn
    print "Total BUSY Transitions: %d" % numBusy
    print "Total OOS Transitions: %d" % numOos
    print "Total ERROR Transitions: %d" % numErr
    print "Total UNKNOWN Transitions: %d" % numOther


    f.close()

if __name__ == '__main__':
    main()
