#!/usr/bin/env python

from rw_reg import *
from mcs import *
from time import *
import sys,os
import array
import struct
import socket

SLEEP_BETWEEN_COMMANDS=0.01
DEBUG=False
CTP7HOSTNAME = "eagle33"

class Colors:
    WHITE   = '\033[97m'
    CYAN    = '\033[96m'
    MAGENTA = '\033[95m'
    BLUE    = '\033[94m'
    YELLOW  = '\033[93m'
    GREEN   = '\033[92m'
    RED     = '\033[91m'
    ENDC    = '\033[0m'

REG_PA_SHIFT_EN       = None
REG_PA_SHIFT_CNT      = None
REG_PA_PHASE          = None
REG_PA_PHASE_MEAN     = None
REG_PA_GTH_SHIFT_EN   = None
REG_PA_GTH_SHIFT_CNT  = None
REG_PA_GTH_PHASE      = None
REG_PA_GTH_PHASE_MEAN = None
REG_PLL_RESET         = None
REG_PLL_LOCKED        = None

PHASE_CHECK_AVERAGE_CNT = 100
PLL_LOCK_WAIT_TIME      = 0.00001 # wait 100us to allow the PLL to lock
PLL_LOCK_READ_ATTEMPTS  = 10

LOCK_FILE = "/tmp/ipbus.lock"

def main(args):

    print(args)
    parseXML()
    initRegAddrs()
    # paGthShiftTest()
    # paShiftTest()
    # paCombinedSwShiftTest()
    # paCombinedHwShiftTest()
    timeoutcnt = 0
    while True:
        if timeoutcnt > 500:
            print("Waiting for lock for 5 seconds, force removing %s"%LOCK_FILE)
            os.remove(LOCK_FILE)
            timeoutcnt = 0
        if os.path.isfile(LOCK_FILE):
            sleep(0.01)
            timeoutcnt += 1
        else:
            with open(LOCK_FILE, "w") as f:
                ret = alignToTtcPhase(args.relock,args.useBC0,args.scan)
            os.remove(LOCK_FILE)
            sys.exit(ret)

def initRegAddrs():
    global REG_PA_SHIFT_EN
    global REG_PA_SHIFT_CNT
    global REG_PA_PHASE
    global REG_PA_PHASE_MEAN
    global REG_PA_GTH_SHIFT_EN
    global REG_PA_GTH_SHIFT_CNT
    global REG_PA_GTH_PHASE
    global REG_PA_GTH_PHASE_MEAN
    global REG_PLL_RESET
    global REG_PLL_LOCKED
    global REG_BC0_LOCKED
    global REG_BC0_UNLOCK_CNT
    global REG_SGL_ERR_CNT
    global REG_DBL_ERR_CNT
    global REG_TTC_CNT_RESET

    REG_PA_SHIFT_EN = getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_EN').real_address
    REG_PA_SHIFT_CNT = getNode('GEM_AMC.TTC.STATUS.CLK.PA_MANUAL_SHIFT_CNT').real_address
    REG_PA_PHASE = getNode('GEM_AMC.TTC.STATUS.CLK.TTC_PM_PHASE').real_address
    REG_PA_PHASE = getNode('GEM_AMC.TTC.STATUS.CLK.TTC_PM_PHASE_MEAN').real_address
    REG_PA_GTH_SHIFT_EN = getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_EN').real_address
    REG_PA_GTH_SHIFT_CNT = getNode('GEM_AMC.TTC.STATUS.CLK.PA_MANUAL_GTH_SHIFT_CNT').real_address
    REG_PA_GTH_PHASE = getNode('GEM_AMC.TTC.STATUS.CLK.GTH_PM_PHASE').real_address
    REG_PA_GTH_PHASE_MEAN = getNode('GEM_AMC.TTC.STATUS.CLK.GTH_PM_PHASE_MEAN').real_address
    REG_PLL_RESET = getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_PLL_RESET').real_address
    REG_PLL_LOCKED = getNode('GEM_AMC.TTC.STATUS.CLK.PHASE_LOCKED').real_address
    REG_BC0_LOCKED = getNode('GEM_AMC.TTC.STATUS.BC0.LOCKED').real_address
    REG_BC0_UNLOCK_CNT = getNode('GEM_AMC.TTC.STATUS.BC0.UNLOCK_CNT').real_address
    REG_SGL_ERR_CNT = getNode('GEM_AMC.TTC.STATUS.TTC_SINGLE_ERROR_CNT').real_address
    REG_DBL_ERR_CNT = getNode('GEM_AMC.TTC.STATUS.TTC_DOUBLE_ERROR_CNT').real_address
    REG_TTC_CNT_RESET = getNode('GEM_AMC.TTC.CTRL.CNT_RESET').real_address

def alignToTtcPhase(shiftOutOfLockFirst,useBC0Locked=False,doScan=False):
    writeReg(getNode('GEM_AMC.TTC.CTRL.DISABLE_PHASE_ALIGNMENT'),       1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_DISABLE_GTH_PHASE_TRACKING'), 1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_OVERRIDE'),            1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'),           1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_OVERRIDE'),        1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'),       0)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_STEP'),      1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SEL_OVERRIDE'),    1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_COMBINED'),        1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.GTH_TXDLYBYPASS'),               1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_PLL_RESET'),           1)
    writeReg(getNode('GEM_AMC.TTC.CTRL.CNT_RESET'),                     1)

    if (parseInt(readReg(getNode('GEM_AMC.TTC.CTRL.DISABLE_PHASE_ALIGNMENT'))) == 0):
        printRed("fail: automatic phase alignment is turned on!!")
        return

    msgfmt  = "mmcm phase counts = {:d}, mmcm phase = {:f}ns, gth phase counts = {:d}, gth phase = {:f}, PLL lock count = {:d}"
    misfmt  = "{0:s} shift count doesn't match the expected {0:s} shift count. Expected shift cnt = {1:d}, ctp7 returned {2:d}"
    statfmt = "bad locks {:d}, good locks {:d}, mmcm phase count = {:d}, mmcm phase ns = {:f}ns"

    readAttempts = 1
    extra = "bc0Locked"
    maxShift   = 7680+(7680/2)

    if not useBC0Locked:
        readAttempts = PLL_LOCK_READ_ATTEMPTS
        extra = "original"

    if doScan:
        readAttempts = PLL_LOCK_READ_ATTEMPTS
        extra += "Scan"
        maxShift = 23040 # 23040 will allow up to 3 times 360 degree shifts to find the lock (should only require 1x 360 in theory)

    with open('alignToTtcPhaseCTP7_{}_{}_{}.csv'.format(socket.gethostname().split('.')[0],extra,int(mktime(gmtime()))), 'w') as f:
        mmcmShiftCnt = rReg(REG_PA_SHIFT_CNT) & 0xffff
        gthShiftCnt  = rReg(REG_PA_GTH_SHIFT_CNT) >> 16
        pllLockCnt   = checkPllLock(readAttempts)
        reversingForLock = False
        firstUnlockFound = False
        nextLockFound    = False
        bestLockFound    = False
        phase   = 0
        phaseNs = 0.0

        mmcmShiftTable = getMmcmShiftTable()

        print("MMCM CNT: {}, GTH CNT: {}, PLL CNT: {}".format(mmcmShiftCnt,gthShiftCnt,pllLockCnt))

        nGoodLocks       = 0
        nShiftsSinceLock = 0
        nBadLocks        = 0
        totalShiftCount  = 0

        for i in range(0, maxShift):
            wReg(REG_PA_GTH_SHIFT_EN, 1)
            tmpGthShiftCnt  = rReg(REG_PA_GTH_SHIFT_CNT) >> 16
            tmpMmcmShiftCnt = rReg(REG_PA_SHIFT_CNT) & 0xffff

            if reversingForLock:
                mmcmShiftRequired = mmcmShiftTable[gthShiftCnt]
            else:
                mmcmShiftRequired = mmcmShiftTable[gthShiftCnt+1]

            if args.d:
                printMagenta("BEFORE: mmcmShift: {}({}) -- gthShift: {}({}) -- {}".format(mmcmShiftCnt,
                                                                                          tmpMmcmShiftCnt,
                                                                                          gthShiftCnt,
                                                                                          tmpGthShiftCnt,
                                                                                          mmcmShiftRequired))

            if not reversingForLock and gthShiftCnt == 39:
                if args.d:
                    printMagenta("DEBUG: normal GTH shift rollover 39->0")
                gthShiftCnt = 0
            elif reversingForLock and gthShiftCnt == 0:
                if args.d:
                    printYellow("DEBUG: rerversed GTH shift rollover 0->39")
                gthShiftCnt = 39
            else:
                if reversingForLock:
                    gthShiftCnt -= 1
                else:
                    gthShiftCnt += 1

            while gthShiftCnt != tmpGthShiftCnt:
                printRed("Repeating {:s}".format(misfmt.format("GTH PI",gthShiftCnt, tmpGthShiftCnt)))
                wReg(REG_PA_GTH_SHIFT_EN, 1)
                tmpGthShiftCnt  = rReg(REG_PA_GTH_SHIFT_CNT) >> 16

            if mmcmShiftRequired:
                if not reversingForLock and (mmcmShiftCnt == 0xffff):
                    mmcmShiftCnt = 0
                elif reversingForLock and (mmcmShiftCnt == 0x0):
                    mmcmShiftCnt = 0xffff
                else:
                    if reversingForLock:
                        mmcmShiftCnt -= 1
                    else:
                        mmcmShiftCnt += 1

            if args.d:
                printYellow("AFTER: mmcmShift: {}({}) -- gthShift: {}({}) -- {}".format(mmcmShiftCnt,
                                                                                        tmpMmcmShiftCnt,
                                                                                        gthShiftCnt,
                                                                                        tmpGthShiftCnt,
                                                                                        mmcmShiftRequired))

            tmpMmcmShiftCnt = rReg(REG_PA_SHIFT_CNT) & 0xffff
            if mmcmShiftCnt != tmpMmcmShiftCnt:
                printRed("Reported {:s}".format(misfmt.format("MMCM",mmcmShiftCnt,tmpMmcmShiftCnt)))

            pllLockCnt = checkPllLock(readAttempts)
            phase      = int(getPhaseMedian(PHASE_CHECK_AVERAGE_CNT))
            # phase      = int(getPhaseMean(2))
            phaseNs    = phase * 0.01860119
            gthPhase   = int(getGthPhaseMedian(PHASE_CHECK_AVERAGE_CNT))
            # gthPhase   = int(getGthPhaseMean(2))
            gthPhaseNs = gthPhase * 0.01860119

            bc0Locked  = rReg(REG_BC0_LOCKED)
            bc0UnlkCnt = rReg(REG_BC0_UNLOCK_CNT)
            sglErrCnt  = rReg(REG_SGL_ERR_CNT)
            dblErrCnt  = rReg(REG_DBL_ERR_CNT)

            printCyan("GTH shift #{:d} (mmcm shift cnt = {:d}), {:s}".format(i, mmcmShiftCnt, msgfmt.format(phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt)))
            f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))

            if useBC0Locked:
                # 3840 full width of good + bad
                # shift into bad region, not on the edge
                if not firstUnlockFound:
                    bestLockFound = False
                    if bc0Locked == 0:
                        nBadLocks += 1
                        nGoodLocks = 0
                    else:
                        nBadLocks   = 0
                        nGoodLocks += 1
                    # * 100 bad in a row
                    if shiftOutOfLockFirst:
                        if nBadLocks > 100:
                            firstUnlockFound = True
                            printRed("100 unlocks found after {:f} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                    else:
                        if reversingForLock and nBadLocks > 0:
                            printYellow("Bad BC0 lock found at phase count = %d, phase ns = %fns, returning to normal search" % (phase, phaseNs))
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 1)
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 0)
                            bestLockFound    = False
                            reversingForLock = False
                            nGoodLocks       = 0
                        elif nGoodLocks == 200:
                            # reverse direction
                            reversingForLock = True
                            printGreen("200 consecutive good BC0 locks found at phase count = %d, phase ns = %fns, reversing scan direction" % (phase, phaseNs))
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 0)
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 1)
                        if reversingForLock and (nGoodLocks == 300):
                            printGreen("Best lock found after reversing at phase count = %d, phase ns = %fns" % (phase, phaseNs))
                            # shift back half of the known good range
                            bestLockFound    = True
                            f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                            if doScan:
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 1)
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 0)
                                bestLockFound    = False
                                reversingForLock = False
                                nGoodLocks       = 0
                            else:
                                break

                # * shift to first good BC0 locked
                else:
                    if bc0Locked == 0:
                        if nextLockFound:
                            printRed("Unexpected unlock after {:f} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                        nBadLocks += 1
                        # nGoodLocks = 0
                    else:
                        if not nextLockFound:
                            printGreen("Found next lock after {:d} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                            nextLockFound = True
                            nBadLocks     = 0
                        nGoodLocks += 1
                    # * shift 1920 additional GTH shifts to be in the middle of the "good" region (maybe too much?)
                    # maybe look for 200, 500 consecutive good locks and shift backwards half?, for the bc0Locked and not shfitOutOfLockFirst mode
                    if nGoodLocks == 1920:
                        printGreen("Finished 1920 shifts after first good lock: bad locks {:d}, good locks {:d}".format(nBadLocks, nGoodLocks))
                        # for test, roll around 3 times, mark location of best lock, reset procedure
                        bestLockFound    = True
                        f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                        if doScan:
                            nextLockFound    = False
                            firstUnlockFound = False
                            nGoodLocks       = 0
                            nBadLocks        = 0
                            nShiftsSinceLock = 0
                        else:
                            break
            elif True:
                # 3840 full width of good + bad
                # shift into bad region, not on the edge
                if not firstUnlockFound:
                    bestLockFound = False
                    if pllLockCnt < PLL_LOCK_READ_ATTEMPTS:
                        nBadLocks += 1
                        nGoodLocks = 0
                    else:
                        nBadLocks   = 0
                        nGoodLocks += 1
                    # * 500 bad in a row
                    if shiftOutOfLockFirst:
                        if nBadLocks > 500:
                            firstUnlockFound = True
                            printRed("500 unlocks found after {:f} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                    else: ## should not be used for PLL lock method!!
                        if reversingForLock and nBadLocks > 0:
                            printYellow("Bad BC0 lock found at phase count = %d, phase ns = %fns, returning to normal search" % (phase, phaseNs))
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 1)
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 0)
                            bestLockFound    = False
                            reversingForLock = False
                            nGoodLocks       = 0
                        elif nGoodLocks == 50:
                            # reverse direction
                            reversingForLock = True
                            printGreen("50 consecutive good PLL locks found at phase count = %d, phase ns = %fns, reversing scan direction" % (phase, phaseNs))
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 0)
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 1)
                        if reversingForLock and (nGoodLocks == 75):
                            printGreen("Best lock found after reversing at phase count = %d, phase ns = %fns" % (phase, phaseNs))
                            # shift back half of the known good range
                            bestLockFound    = True
                            f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                            if doScan:
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 1)
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 0)
                                bestLockFound    = False
                                reversingForLock = False
                                nGoodLocks       = 0
                            else:
                                break

                # * shift to first good BC0 locked
                else:
                    if pllLockCnt < PLL_LOCK_READ_ATTEMPTS:
                        if nextLockFound:
                            printRed("Unexpected unlock after {:f} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                        nBadLocks += 1
                        # nGoodLocks = 0
                    else:
                        if not nextLockFound:
                            printGreen("Found next lock after {:d} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                            nextLockFound = True
                            nBadLocks     = 0
                        nGoodLocks += 1
                    # * shift 1000 additional GTH shifts to be in the middle of the "good" region
                    ## Maybe just find 50-75 consecutive good locks?
                    if nShiftsSinceLock == 1000:
                        printGreen("Finished 1000 shifts after first good lock: bad locks {:d}, good locks {:d}".format(nBadLocks, nGoodLocks))
                        # for a scan, mark location of best lock, reset procedure
                        bestLockFound    = True
                        f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                        if doScan:
                            nextLockFound    = False
                            firstUnlockFound = False
                            nGoodLocks       = 0
                            nBadLocks        = 0
                            nShiftsSinceLock = 0
                        else:
                            break
                pass
            else:  ## Use PLL lock status
                if shiftOutOfLockFirst and (pllLockCnt < PLL_LOCK_READ_ATTEMPTS) and not firstUnlockFound:
                    firstUnlockFound = True
                    printRed("Unlocked after {:d} shifts, mmcm phase count = {:d}, mmcm phase ns = {:f}ns".format(i+1, phase, phaseNs))

                if pllLockCnt == PLL_LOCK_READ_ATTEMPTS:
                    if not shiftOutOfLockFirst:
                        if nGoodLocks == 200:
                            # reverse direction
                            reversingForLock = True
                            printGreen("200 consecutive good PLL locks found at phase count = %d, phase ns = %fns, reversing scan direction" % (phase, phaseNs))
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 0)
                            writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 1)
                        if reversingForLock and (nGoodLocks == 300):
                            printGreen("Best lock found after reversing at phase count = %d, phase ns = %fns" % (phase, phaseNs))
                            # shift back half of the known good range
                            bestLockFound    = True
                            f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                            if doScan:
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_MANUAL_SHIFT_DIR'), 1)
                                writeReg(getNode('GEM_AMC.TTC.CTRL.PA_GTH_MANUAL_SHIFT_DIR'), 0)
                                bestLockFound    = False
                                reversingForLock = False
                                nGoodLocks       = 0
                                nShiftsSinceLock = 0
                            else:
                                break
                    elif firstUnlockFound or not shiftOutOfLockFirst:
                        if not nextLockFound:
                            printGreen("Found next lock after {:d} shifts: {:s}".format(i+1, statfmt.format(nBadLocks, nGoodLocks, phase, phaseNs)))
                        nextLockFound = True
                        # if nGoodLocks > 4:
                        if nShiftsSinceLock > 500:
                            bestLockFound = True
                            f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                            if not doScan:
                                break;
                            nextLockFound    = False
                            firstUnlockFound = False
                            bestLockFound    = False
                            nGoodLocks       = 0
                            nShiftsSinceLock = 0

                    else:
                        nGoodLocks += 1
                elif nextLockFound:
                    if nShiftsSinceLock > 500:
                        bestLockFound = True
                        f.write("%d,%d,%d,%f,%d,%f,%d,%d,%d,%d,%d\n" % (i,totalShiftCount, phase, phaseNs, gthPhase, gthPhaseNs, pllLockCnt,bc0Locked,sglErrCnt,dblErrCnt,int(bestLockFound)))
                        if not doScan:
                            break;
                        nextLockFound    = False
                        firstUnlockFound = False
                        bestLockFound    = False
                        nGoodLocks       = 0
                        nShiftsSinceLock = 0
                else:
                    bestLockFound = False
                    nBadLocks += 1
                    # nGoodLocks = 0

            if nextLockFound:
                nShiftsSinceLock += 1
            if reversingForLock:
                totalShiftCount -= 1
            else:
                totalShiftCount += 1

    print("")
    print("=============================================================")
    # if (pllLockCnt == PLL_LOCK_READ_ATTEMPTS):
    if (bestLockFound):
        printGreen("==== Lock was found at phase count = %d, phase ns = %fns ====" % (phase, phaseNs))
	writeReg(getNode('GEM_AMC.TTC.CTRL.MODULE_RESET'), 1)
        return 0
    else:
        printRed("====              Lock was not found.... :(              ====")
        return 1

def getMmcmShiftTable():
    pi_step_size=(1000./4800.)/64.
    mmcm_step_size=(1000./960.)/56.
    pi_steps=[i*pi_step_size for i in range(0,41)]
    mmcm_steps=[i*mmcm_step_size  for i in range(0,8)]
    mmcm=0

    mmcm_val=0
    shiftNext=False
    res = []
    for i,pistep in enumerate(pi_steps):
        shiftNow=False
        mmcm_comp=mmcm_steps[mmcm]+(mmcm_step_size/2)
        try:
            if mmcm_comp >= (pi_steps[i]) and mmcm_comp <= (pi_steps[i+1]):
                shiftNext=True
            else:
                if shiftNext:
                    mmcm += 1
                    mmcm_val = mmcm_steps[mmcm]
                    shiftNow=True
                    shiftNext=False
        except IndexError:
            pass
        res.append(shiftNow)
        print("{:d}  {:8.6f}  {:8.6f}  {:10.6f}  {:d}  {}".format(i,pistep,mmcm_val,pistep-mmcm_val,mmcm,shiftNow))

    print(len(res),res)
    return res

def checkPllLock(readAttempts):
    lockCnt = 0
    for i in range(0, readAttempts):
        wReg(REG_PLL_RESET, 1)
        sleep(PLL_LOCK_WAIT_TIME)
        if ((rReg(REG_PLL_LOCKED) & 0x4) >> 2) != 0:
            lockCnt += 1
    return lockCnt

def getPhaseMean(numIterations):
    phase = 0
    return rReg(REG_PA_PHASE_MEAN) & 0xfff
    # for i in range(0, numIterations):
    #     phase += rReg(REG_PA_PHASE_MEAN) & 0xfff
    #     sleep(0.001126) #takes 1.126ms for the firmware to update the phase mean register

    # phase = phase / numIterations
    # return phase

def getPhaseMedian(numIterations):
    phases = []
    for i in range(0, numIterations):
        phases.append(rReg(REG_PA_PHASE) & 0xfff)

    phase = median(phases)
    return phase

def getGthPhaseMean(numIterations):
    phase = 0
    return rReg(REG_PA_GTH_PHASE_MEAN) & 0xfff
    # for i in range(0, numIterations):
    #     phase += rReg(REG_PA_GTH_PHASE_MEAN) & 0xfff
    #     sleep(0.000375) #takes 375us for the firmware to update the phase mean register

    # phase = phase / numIterations
    # return phase

def getGthPhaseMedian(numIterations):
    phases = []
    for i in range(0, numIterations):
        phases.append(rReg(REG_PA_GTH_PHASE) & 0xfff)

    phase = median(phases)
    return phase

def checkStatus():
    rxReady       = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.STATUS.READY')))
    criticalError = parseInt(readReg(getNode('GEM_AMC.SLOW_CONTROL.SCA.STATUS.CRITICAL_ERROR')))
    return (rxReady == 1) and (criticalError == 0)

def median(lst):
    n = len(lst)
    if n < 1:
            return None
    if n % 2 == 1:
            return sorted(lst)[n//2]
    else:
            return sum(sorted(lst)[n//2-1:n//2+1])/2.0

def check_bit(byteval,idx):
    return ((byteval&(1<<idx))!=0);

def debug(string):
    if DEBUG:
        print('DEBUG: ' + string)

def debugCyan(string):
    if DEBUG:
        printCyan('DEBUG: ' + string)

def heading(string):
    print Colors.BLUE
    print '\n>>>>>>> '+str(string).upper()+' <<<<<<<'
    print Colors.ENDC

def subheading(string):
    print Colors.YELLOW
    print '---- '+str(string)+' ----',Colors.ENDC

def printCyan(string):
    print Colors.CYAN, string, Colors.ENDC

def printMagenta(string):
    print Colors.MAGENTA, string, Colors.ENDC

def printYellow(string):
    print Colors.YELLOW, string, Colors.ENDC

def printRed(string):
    print Colors.RED, string, Colors.ENDC

def printGreen(string):
    print Colors.GREEN, string, Colors.ENDC

def hex(number):
    if number is None:
        return 'None'
    else:
        return "{0:#0x}".format(number)

def binary(number, length):
    if number is None:
        return 'None'
    else:
        return "{0:#0{1}b}".format(number, length + 2)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()

    parser.add_argument("--relock",    help="Shift out of locked state initially", action='store_true')
    parser.add_argument("--useBC0",    help="Use BC0 lock status", action='store_true')
    parser.add_argument("--scan",      help="Do a full phase scan", action='store_true')
    parser.add_argument("-d",          help="debug", action='store_true')

    args = parser.parse_args()
    main(args)
