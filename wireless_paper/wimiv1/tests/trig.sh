#!/bin/bash
transferSize=16383
transferCount=2
./reg_rw /dev/xdma0_user 0x4000 w 0x10000
./reg_rw /dev/xdma0_user 0x4004 w 0x3fff
./reg_rw /dev/xdma0_user 0x4008 w 0x1 
./reg_rw /dev/xdma0_user 0x400c w 0x1
