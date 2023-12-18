#!/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Copyright (C) 2019 Western Digital Corporation or its affiliates.
#

. scripts/test_lib

if [ $# == 0 ]; then
        echo "Number of blocks using stat (default)"
        exit 0
fi

echo "Check for number of blocks for the file system"

zonefs_mkfs "$1"
zonefs_mount "$1"

nr_blocks=$(block_number "$zonefs_mntdir")
sz_blocks=$(block_size "$zonefs_mntdir")
capacity_bytes=$(( total_usable_sectors * 512))
nr_expected_blocks=$(( capacity_bytes / sz_blocks ))

echo "$nr_blocks $sz_blocks $total_usable_sectors $nr_expected_blocks"

if [ "$nr_blocks" != "$nr_expected_blocks" ]; then
        echo " --> Invalid total number of blocks:"
        echo " --> Expected $nr_expected_blocks, got $nr_blocks"
        exit 1
fi

zonefs_umount

exit 0
