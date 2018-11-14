#!/usr/bin/env python

from utils import *
import signal
import sys
import os
import struct
import zlib
import math
import analyze_events

class GemEvent(object):

    #header data
    amcNum = None
    l1aId = None
    bxId = None
    formatVersion = None
    runType = None
    runParams = None
    orbitId = None
    boardId = None
    davList = None
    bufStatus = None
    davCount = None
    ttsState = None

    #trailer data
    davTimeoutFlags = None
    daqAlmostFull = None
    mmcmLocked = None
    daqClkLocked = None
    daqReady = None
    bc0Locked = None
    l1aIdTrail = None
    wordCnt = None

    chambers = []

    def __init__(self):
        self.chambers = []
        pass

    def unpackGemFedBlock(self, str, verbose=False):
        #pad with zeros if necessary to align to 64bit boundary
        while len(str) % 8 != 0:
            if verbose:
                print "adding a zero at the end of the string to align to 64bit boundary"
            str += '\0'

        words = struct.unpack("%dQ" % int(len(str) / 8), str)

        idx = self.unpackGemAmcHeader(words, 0, verbose)
        idx = self.unpackGemEventHeader(words, idx, verbose)
        chamberIdx = 0
        while chamberIdx < self.davCount:
            chamber = GemChamber(self, chamberIdx)
            self.chambers.append(chamber)
            chamberIdx += 1
            idx = chamber.unpackGemChamberBlock(words, idx, verbose)

        idx = self.unpackGemEventTrailer(words, idx, verbose)
        idx = self.unpackGemAmcTrailer(words, idx, verbose)

    def unpackGemAmcHeader(self, words, idx, verbose=False):
        self.amcNum = (words[idx] >> 56) & 0xf
        self.l1aId = (words[idx] >> 32) & 0xffffff
        self.bxId = (words[idx] >> 20) & 0xfff
        idx += 1
        self.formatVersion = (words[idx] >> 60) & 0xf
        self.runType = (words[idx] >> 56) & 0xf
        self.runParams = (words[idx] >> 32) & 0xffffff
        self.orbitId = (words[idx] >> 16) & 0xffff
        self.boardId = (words[idx] >> 0) & 0xffff
        idx += 1

        if verbose:
            self.printGemAmcHeader()

        return idx

    def printGemAmcHeader(self):
        printCyan("--------------------------------------")
        printCyan("AMC Header")
        printCyan("--------------------------------------")
        print "Format version: %d" % self.formatVersion
        print "AMC number: %d" % self.amcNum
        print "Board ID: %s" % hexPadded(self.boardId, 2)
        print "L1A ID: %d" % self.l1aId
        print "Orbit ID: %d" % self.orbitId
        print "BX ID: %d" % self.bxId
        print "Run type: %d" % self.runType
        print "Run params: %s" % hexPadded(self.runParams, 3)

    def unpackGemEventHeader(self, words, idx, verbose=False):
        self.davList = (words[idx] >> 40) & 0xffffff
        self.bufStatus = (words[idx] >> 16) & 0xffffff
        self.davCount = (words[idx] >> 11) & 0x1f
        self.ttsState = (words[idx] >> 0) & 0xf
        idx += 1

        if verbose:
            self.printGemEventHeader()

        return idx

    def printGemEventHeader(self):
        printCyan("--------------------------------------")
        printCyan("GEM Event Header")
        printCyan("--------------------------------------")
        print "DAV count: %d" % self.davCount
        print "DAV list: %s" % hexPadded(self.davList, 3)
        printGreenRed("Buffer status: %s" % hexPadded(self.bufStatus, 3), self.bufStatus, 0)
        printGreenRed("TTS state: %s" % hexPadded(self.ttsState, 1), self.ttsState, 8)


    def unpackGemEventTrailer(self, words, idx, verbose=False):
        self.davTimeoutFlags = (words[idx] >> 40) & 0xffffff
        self.daqAlmostFull = True if ((words[idx] >> 7) & 0x1) == 1 else False
        self.mmcmLocked = True if ((words[idx] >> 6) & 0x1) == 1 else False
        self.daqClkLocked = True if ((words[idx] >> 5) & 0x1) == 1 else False
        self.daqReady = True if ((words[idx] >> 4) & 0x1) == 1 else False
        self.bc0Locked = True if ((words[idx] >> 3) & 0x1) == 1 else False
        idx += 1

        if verbose:
            self.printGemEventTrailer()

        return idx


    def printGemEventTrailer(self):
        printCyan("--------------------------------------")
        printCyan("GEM Event Trailer")
        printCyan("--------------------------------------")
        printGreenRed("DAV timeout flags: %s" % hexPadded(self.davTimeoutFlags, 3), self.davTimeoutFlags, 0)
        printGreenRed("DAQ almost full: %r" % self.daqAlmostFull, self.daqAlmostFull, False)
        printGreenRed("MMCM locked: %r" % self.mmcmLocked, self.mmcmLocked, True)
        printGreenRed("DAQ clock locked: %r" % self.daqClkLocked, self.daqClkLocked, True)
        printGreenRed("DAQ ready: %r" % self.daqReady, self.daqReady, True)
        printGreenRed("BC0 locked: %r" % self.bc0Locked, self.bc0Locked, True)


    def unpackGemAmcTrailer(self, words, idx, verbose=False):
        self.l1aIdTrail = (words[idx] >> 24) & 0xff
        self.wordCnt = (words[idx] >> 0) & 0xfffff
        idx += 1

        if verbose:
            self.printGemAmcTrailer(idx)

        return idx


    def printGemAmcTrailer(self, idx=-1):
        printCyan("--------------------------------------")
        printCyan("GEM AMC Trailer")
        printCyan("--------------------------------------")
        printGreenRed("L1A ID in the trailer: %d" % self.l1aIdTrail, self.l1aIdTrail, self.l1aId & 0xff)
        if idx == -1:
            print "Total 64bit word count: %d" % self.wordCnt
        else:
            printGreenRed("Total 64bit word count: %d" % self.wordCnt, self.wordCnt, idx)

    def printEvent(self):
        self.printGemAmcHeader()
        self.printGemEventHeader()
        for chamber in self.chambers:
            chamber.printChamber()
        self.printGemEventTrailer()
        self.printGemAmcTrailer()

    def getNumVfatBlocks(self):
        numVfats = 0
        for chamber in self.chambers:
            numVfats += len(chamber.vfats)

        return numVfats

class GemChamber(object):

    event = None
    chamberIdx = None

    #header data
    zsWordCnt = None
    inputId = None
    vfatWordCnt = None
    evtFifoFull = None
    inFifoFull = None
    l1aFifoFull = None
    evtSizeOvf = None
    evtFifoNearFull = None
    inFifoNearFull = None
    l1aFifoNearFull = None
    evtSizeMoreThan24 = None
    noVfatMarker = None

    #trailer data
    vfatWordCntTrail = None
    evtFifoUnf = None
    inFifoUnf = None
    ohEc = None
    ohBc = None

    #vfat data
    vfats = []

    def __init__(self, event, chamberIdx):
        self.event = event
        self.chamberIdx = chamberIdx
        self.vfats = []

    def unpackGemChamberBlock(self, words, idx, verbose=False):
        idx = self.unpackGemChamberHeader(words, idx, verbose)

        if self.vfatWordCnt % 3 != 0:
            printRed("Invalid VFAT word count that doesn't divide by 3: %d !! exiting.." % self.vfatWordCnt)
            sys.exit(0)

        vfatIdx = 0
        while vfatIdx < self.vfatWordCnt / 3:
            vfat = GemVfat2(self, vfatIdx)
            self.vfats.append(vfat)
            vfatIdx += 1
            idx = vfat.unpackVfatBlock(words, idx, verbose)

        idx = self.unpackGemChamberTrailer(words, idx, verbose)

        return idx

    def unpackGemChamberHeader(self, words, idx, verbose=False):
        self.zsWordCnt = (words[idx] >> 40) & 0xfff
        self.inputId = (words[idx] >> 35) & 0x1f
        self.vfatWordCnt = (words[idx] >> 23) & 0xfff
        self.evtFifoFull = True if ((words[idx] >> 22) & 0x1) == 1 else False
        self.inFifoFull = True if ((words[idx] >> 21) & 0x1) == 1 else False
        self.l1aFifoFull = True if ((words[idx] >> 20) & 0x1) == 1 else False
        self.evtSizeOvf = True if ((words[idx] >> 19) & 0x1) == 1 else False
        self.evtFifoNearFull = True if ((words[idx] >> 18) & 0x1) == 1 else False
        self.inFifoNearFull = True if ((words[idx] >> 17) & 0x1) == 1 else False
        self.l1aFifoNearFull = True if ((words[idx] >> 16) & 0x1) == 1 else False
        self.evtSizeMoreThan24 = True if ((words[idx] >> 15) & 0x1) == 1 else False
        self.noVfatMarker = True if ((words[idx] >> 14) & 0x1) == 1 else False

        idx += 1

        if verbose:
            self.printGemChamberHeader()

        return idx

    def printGemChamberHeader(self):
        printCyan("    --------------------------------------")
        printCyan("    Chamber #%d Event Header" % self.chamberIdx)
        printCyan("    --------------------------------------")
        print "    Zero-suppressed word count: %d" % self.zsWordCnt
        print "    Input ID: %d" % self.inputId
        print "    VFAT word count: %d" % self.vfatWordCnt
        printGreenRed("    Event FIFO full: %r" % self.evtFifoFull, self.evtFifoFull, False)
        printGreenRed("    Input FIFO full: %r" % self.inFifoFull, self.inFifoFull, False)
        printGreenRed("    L1A FIFO full: %r" % self.l1aFifoFull, self.l1aFifoFull, False)
        printGreenRed("    Event size overflow: %r" % self.evtSizeOvf, self.evtSizeOvf, False)
        printGreenRed("    Event FIFO near full: %r" % self.evtFifoNearFull, self.evtFifoNearFull, False)
        printGreenRed("    Input FIFO near full: %r" % self.inFifoNearFull, self.inFifoNearFull, False)
        printGreenRed("    L1A FIFO near full: %r" % self.l1aFifoNearFull, self.l1aFifoNearFull, False)
        printGreenRed("    Event size more than 24 VFATs: %r" % self.evtSizeMoreThan24, self.evtSizeMoreThan24, False)
        printGreenRed("    No VFAT marker: %r" % self.noVfatMarker, self.noVfatMarker, False)


    def unpackGemChamberTrailer(self, words, idx, verbose=False):
        self.vfatWordCntTrail = (words[idx] >> 36) & 0xfff
        self.evtFifoUnf = True if ((words[idx] >> 35) & 0x1) == 1 else False
        self.inFifoUnf = True if ((words[idx] >> 33) & 0x1) == 1 else False
        self.ohBc = (words[idx] >> 20) & 0xfff
        self.ohEc = (words[idx] >> 0) & 0xfffff

        idx += 1

        if verbose:
            self.printGemChamberTrailer()

        return idx


    def printGemChamberTrailer(self):
        printCyan("    --------------------------------------")
        printCyan("    Chamber #%d Event Trailer" % self.chamberIdx)
        printCyan("    --------------------------------------")
        printGreenRed("    VFAT word count in trailer: %d" % self.vfatWordCntTrail, self.vfatWordCntTrail, self.vfatWordCnt)
        printGreenRed("    Event FIFO underflow: %r" % self.evtFifoUnf, self.evtFifoUnf, False)
        printGreenRed("    Input FIFO underflow: %r" % self.inFifoUnf, self.inFifoUnf, False)
        print "    OH EC: %d" % self.ohEc
        printGreenRed("    OH BC: %d" % self.ohBc, self.ohBc, self.event.bxId + 1)


    def printChamber(self):
        self.printGemChamberHeader()
        for vfat in self.vfats:
            vfat.printVfat2Block()
        self.printGemChamberTrailer()

class GemVfat2(object):

    chamber = None
    vfatIdx = None

    marker = None
    bc = None
    ec = None
    chipId = None
    hammingErr = None
    almostFull = None
    seuLogic = None
    seuI2C = None
    chanData = None
    numHits = None
    crc = None

    def __init__(self, chamber, vfatIdx):
        self.chamber = chamber
        self.vfatIdx = vfatIdx

    def unpackVfatBlock(self, words, idx, verbose=False):
        self.marker = ((words[idx] >> 60) & 0xf) << 8
        self.bc = (words[idx] >> 48) & 0xfff
        self.marker += ((words[idx] >> 44) & 0xf) << 4
        self.ec = (words[idx] >> 36) & 0xff
        self.hammingErr = True if ((words[idx] >> 35) & 0x1) == 1 else False
        self.almostFull = True if ((words[idx] >> 34) & 0x1) == 1 else False
        self.seuLogic = True if ((words[idx] >> 33) & 0x1) == 1 else False
        self.seuI2C = True if ((words[idx] >> 32) & 0x1) == 1 else False
        self.marker += (words[idx] >> 28) & 0xf
        self.chipId = (words[idx] >> 16) & 0xfff
        self.chanData = ((words[idx] >> 0) & 0xffff) << 112
        idx += 1
        self.chanData += words[idx] << 48
        idx += 1
        self.chanData += (words[idx] >> 16) & 0xffffffffffff
        self.crc = (words[idx] >> 0) & 0xffff
        idx += 1
        self.numHits = bin(self.chanData).count("1")

        if verbose:
            self.printVfat2Block()

        return idx

    def printVfat2Block(self):
        printCyan("        --------------------------------------")
        printCyan("        VFAT Block #%d" % self.vfatIdx)
        printCyan("        --------------------------------------")
        printGreenRed("        BC: %d" % self.bc, self.bc, self.chamber.event.bxId)
        print "        EC: %d" % self.ec
        print "        Chip ID: %s" % hexPadded(self.chipId, 1.5)
        printGreenRed("        Marker: %s" % hexPadded(self.marker, 1.5), self.marker, 0xace)
        printGreenRed("        Hamming error: %r" % self.hammingErr, self.hammingErr, False)
        printGreenRed("        Almost full: %r" % self.almostFull, self.almostFull, False)
        printGreenRed("        SEU logic: %r" % self.seuLogic, self.seuLogic, False)
        printGreenRed("        SEU I2C: %r" % self.seuI2C, self.seuI2C, False)
        print "        Channel data: %s" % hexPadded(self.chanData, 16)
        print "        Number of hit channels: %d" % self.numHits
        print "        CRC: %s" % hexPadded(self.crc, 2)


def main():

    rawFilename = ''
    command = ''
    evtNumToPrint = -1
    countNonZero = False

    if len(sys.argv) < 3:
        print('Usage: unpack.py <gem_raw_file> <command> [command_params]')
        print('Commands:')
        print('    print <evt_number> -- prints the requested event')
        print('    print_non_zero_event <non_zero_evt_number> -- prints the requested event while only counting events that contain at least one vfat block')
        return
    else:
        rawFilename = sys.argv[1]
        command = sys.argv[2]

    if "print" in command:
        evtNumToPrint = int(sys.argv[3])
    if "non_zero_event" in command:
        countNonZero = True

    if not os.path.exists(rawFilename):
        print "Input file %s does not exist." % rawFilename
        return

    f = open(rawFilename, 'rb')
    fileSize = os.fstat(f.fileno()).st_size

    evtHeaderSize = readInitRecord(f)
    print "File size = %d bytes" % fileSize

    events = []
    i = 0
    nonZeroI = 0
    while True:
        if f.tell() >= fileSize - 1:
            printCyan("End of file reached")
            f.close()
            break

        event = readEvtRecord(f, fileSize, evtHeaderSize)
        if event is not None:
            events.append(event)

            if not countNonZero and (i == evtNumToPrint):
                event.printEvent()
                printRed("Event #%d (ending at byte %d in the file)" % (i, f.tell()))
                break
            elif countNonZero and (event.getNumVfatBlocks() > 0):
                if nonZeroI == evtNumToPrint:
                    event.printEvent()
                    printRed("Event #%d (ending at byte %d in the file)" % (i, f.tell()))
                    break
                nonZeroI += 1

            i += 1

        #print "Read event #%d ending at byte %d" % (i, f.tell())

    f.close()

    # some quick and dirty analysis runs
    if "analyze_bx" in sys.argv:
        analyze_events.analyzeBx(events)

    if "analyze_num_chambers" in sys.argv:
        analyze_events.analyzeNumChambers(events)

def readInitRecord(f, verbose=False):
    code = readNumber(f, 1)
    initRecordSize = readNumber(f, 4)
    protocol = readNumber(f, 1)
    f.read(16)
    runNumber = readNumber(f, 4)
    initHeaderSize = readNumber(f, 4)
    evtHeaderSize = readNumber(f, 4)
    f.read(initRecordSize - 34) # finish reading the init block

    if verbose:
        print ""
        print "====================================================="
        print "INIT MESSAGE"
        print "====================================================="
        print "code = %s" % hexPadded(code, 1)
        print "size = %d" % initRecordSize
        print "protocol = %s" % hexPadded(protocol, 1)
        print "run number = %d" % runNumber
        print "init header size = %d" % initHeaderSize
        print "event header size = %d" % evtHeaderSize

    return evtHeaderSize

def readEvtRecord(f, fileSize, evtHeaderSize, verbose=False, debug=False):
    startIdx = f.tell()
    code = readNumber(f, 1)
    size = readNumber(f, 4)
    protocol = readNumber(f, 1)
    runNumber = readNumber(f, 4)
    evtNumber = readNumber(f, 4)
    f.read(evtHeaderSize - 14 - 4)
    fedBlockSizeCompressed = readNumber(f, 4)
    compressedEvtBlobIdx = f.tell()
    if compressedEvtBlobIdx + fedBlockSizeCompressed >= fileSize:
        f.read(fileSize - compressedEvtBlobIdx)
        if verbose:
            printRed("End of file reached")
        return None
    fedDataCompressed = f.read(fedBlockSizeCompressed)
    fedData = zlib.decompress(fedDataCompressed)[0x1c81:] #0x1c81 is a magic position inside this blob where I found the FED data to start totally emptyrically, so it may not be true for each file...
    fedBlockSize = len(fedData)

    if verbose:
        print ""
        print "====================================================="
        print "EVENT MESSAGE"
        print "====================================================="
        print "start idx = %s" % hexPadded(startIdx, 4)
        print "code = %s" % hexPadded(code, 1)
        print "size = %d" % size
        print "protocol = %s" % hexPadded(protocol, 1)
        print "run number = %d" % runNumber
        print "event number = %d" % evtNumber

        print "compressed event blob size = %d" % fedBlockSizeCompressed
        print "compressed event blob idx: %s" % hexPadded(compressedEvtBlobIdx, 4)

        print "decompressed event blob size = %d" % fedBlockSize

        if debug:
            print "----------------------------------------------"
            print "FED data:"
            printHexBlock64BigEndian(fedData, fedBlockSize)
            print "----------------------------------------------"

        printCyan("**********************************************")

    event = GemEvent()
    event.unpackGemFedBlock(fedData, verbose)

    if verbose:
        printCyan("**********************************************")

    return event

def readNumber(f, numBytes):
    formatStr = "<"
    if numBytes == 1:
        formatStr += "B"
    elif numBytes == 2:
        formatStr += "H"
    elif numBytes == 4:
        formatStr += "I"
    elif numBytes == 8:
        formatStr += "Q"
    else:
        raise "Unsupported number byte count of %d" % numBytes

    word = struct.unpack(formatStr, f.read(numBytes))[0]

    return word

def printHexBlock64BigEndian(str, length):
    fedBytes = struct.unpack("%dB" % length, str)
    # print "length: %d, str length: %d, num of 8 byte words: %d" % (len(fedBytes), len(str), int(math.ceil(length / 8.0)))
    for i in range(0, int(math.ceil(length / 8.0))):
        idx = i * 8
        sys.stdout.write("{0:#0{1}x}: ".format(idx, 4 + 2))
        # sys.stdout.write("%d: " % idx)
        for j in range(0, 8):
            if (i+1) * 8 - (j + 1) >= length:
                sys.stdout.write("-- ")
            else:
                sys.stdout.write("%s " % (format(fedBytes[(i+1) * 8 - (j + 1)], '02x')))
        sys.stdout.write('\n')
    sys.stdout.flush()

if __name__ == '__main__':
    main()
