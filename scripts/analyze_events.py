#!/usr/bin/env python

from utils import *
import math
from text_histogram import histogram

def analyzeBx(events):
    ohAmcBxOffsets = []
    vfatOhBxOffsets = []
    vfatAmcBxOffsets = []

    for event in events:
        for chamber in event.chambers:
            ohAmcBxOffsets.append(chamber.ohBc - event.bxId)
            for vfat in chamber.vfats:
                vfatOhBxOffsets.append(vfat.bc - chamber.ohBc)
                vfatAmcBxOffsets.append(vfat.bc - event.bxId)

    print "===================================================="
    print "OH BC - AMC BC histogram:"
    print ""
    histogram(ohAmcBxOffsets, -3564, 3564, 100)

    print ""
    print "===================================================="
    print "VFAT BC - OH BC histogram:"
    print ""
    histogram(vfatOhBxOffsets, -3564, 3564, 100)

    print ""
    print "===================================================="
    print "VFAT BC - AMC BC histogram:"
    print ""
    histogram(vfatAmcBxOffsets, -3564, 3564, 100)

def analyzeNumChambers(events):
    numChambers = []

    for event in events:
        numChambers.append(len(event.chambers))

    print "===================================================="
    print "Number of chambers per event histogram:"
    print ""
    histogram(numChambers, 0, 8, 8)
