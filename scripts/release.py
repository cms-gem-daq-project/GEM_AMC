#!/usr/bin/env python

import argparse
import os
import shutil
import re
import hashlib

#Note this module has the following dependencies:
#  * argparse: pip install argparse
#  * pygithub: pip install pygithub

RELEASE_BASE_DIR="../releases"
BITFILE="../ctp7/work_dir/gem_amc.runs/impl_1/gem_ctp7.bit"
DEBUG_PROBES_FILE="../ctp7/work_dir/gem_amc.runs/impl_1/debug_nets.ltx"
ADDRESS_TABLE_DIR="./address_table"
ADDRESS_TABLE_MAIN_FILE="./address_table/gem_amc_top.xml"

def main():
    parser = argparse.ArgumentParser(description='This script helps you create GEM_AMC releases.')
    parser.add_argument('-v', metavar='version', required=True,
                   help='Required: Release version e.g. 3.5.0')
    parser.add_argument('-oh', metavar='num_optohybrids', required=True, type=int,
                   help='Required: Number of optohybrids supported by this release')
    parser.add_argument('-linux', metavar='linux_image_file', required=True,
                   help='Required: Linux image file e.g. ../images/LinuxImage-CTP7-GENERIC-20180529T153916-0500-4935611.img')
    parser.add_argument('-linux_hash', metavar='linux_hash',
                   help='Optional: If the linux image filename is of the standard format (e.g. LinuxImage-CTP7-GENERIC-20180529T153916-0500-4935611.img), then the hash will be taken from the filename unless this is specified. If the filename has a different format, then you will need to provide this argument')
    args = parser.parse_args()

    if not os.path.isdir(RELEASE_BASE_DIR):
        print "Release directory %s does not exist. Make sure you're running the script from the GEM_AMC/scripts directory" % RELEASE_BASE_DIR
        return

    if not os.path.exists(BITFILE):
        print "Bitfile %s does not exist. Make sure you have the bitfile compiled, and you're running this script from the GEM_AMC/scripts directory" % BITFILE
        return

    if not os.path.exists(DEBUG_PROBES_FILE):
        print "Debug probes file %s does not exist. Make sure you have the bitfile compiled, and you're running this script from the GEM_AMC/scripts directory" % DEBUG_PROBES_FILE
        return

    if not os.path.exists(args.linux):
        print "Linux image file %s does not exist." % args.linux
        return

    if not os.path.isdir(ADDRESS_TABLE_DIR):
        print "Address table directory %s does not exist. Make sure you're running the script from the GEM_AMC/scripts directory" % ADDRESS_TABLE_DIR
        return;

    if not os.path.exists(ADDRESS_TABLE_MAIN_FILE):
        print "The main address table file %s does not exist. Make sure you're running the script from the GEM_AMC/scripts directory" % ADDRESS_TABLE_MAIN_FILE
        return;

    linux_hash = args.linux_hash

    if linux_hash is None:
        linux_re = re.compile(".*LinuxImage-CTP7-GENERIC-(\d{8,8})T([\w-]{19,19})\\.img")
        linux_match = linux_re.match(args.linux)
        if linux_match is None:
            print "Linux image filename does not follow the standard format, so we can't parse hash from the filename. Please provide -linux_hash argument."
            print "Standard linux image filename looks like this: LinuxImage-CTP7-GENERIC-20180529T153916-0500-4935611.img"
            return
        else:
            linux_hash = linux_match.group(2)
            print "Linux hash parsed from the filename: %s" % linux_hash

    version_no_dots = args.v.replace(".", "_")
    release_dir = RELEASE_BASE_DIR + "/v" + version_no_dots

    if os.path.isdir(release_dir):
        print "Release directory %s already exists." % release_dir
        return

    print "******** Creating release v%s with %d OHs ********" % (args.v, args.oh)

    os.makedirs(release_dir)

    relname_bitfile = "gem_ctp7_v%s_%doh.bit" % (version_no_dots, args.oh)
    relname_debug_probes = "gem_ctp7_v%s_%doh.ltx" % (version_no_dots, args.oh)

    shutil.copy(BITFILE, release_dir + "/" + relname_bitfile)
    shutil.copy(DEBUG_PROBES_FILE, release_dir + "/" + relname_debug_probes)
    shutil.copy(args.linux, release_dir + "/")
    relname_address_table_dir = release_dir + "/address_table_v%s_%doh" % (version_no_dots, args.oh)
    shutil.copytree(ADDRESS_TABLE_DIR, relname_address_table_dir)

    f = open(release_dir + "/release_info_v%s.txt" % version_no_dots, 'w')
    f.write("linux_hash=%s\n" % linux_hash)
    f.write("linux_filename=%s\n" % os.path.basename(args.linux))
    f.write("num_oh=%d\n" % args.oh)
    f.write("md5_%s=%s\n" % (relname_bitfile, md5(BITFILE)))
    f.write("md5_%s=%s\n" % (relname_debug_probes, md5(DEBUG_PROBES_FILE)))
    f.write("md5_%s=%s\n" % (os.path.basename(args.linux), md5(args.linux)))

    f.close()


def md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

if __name__ == '__main__':
    main()