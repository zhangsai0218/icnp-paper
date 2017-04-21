#!/bin/bash
transferSize=512
transferCount=1
#rm -f rx.bin
#./trig.sh
./reg_rw /dev/xdma0_user 0x1008 w 0x01
./dma_to_device -d /dev/xdma0_h2c_0 -f data/datafile0_4K.bin -s $transferSize -c $transferCount &
./reg_rw /dev/xdma0_user 0x1004 w 0x02

 #./dma_from_device -d /dev/xdma0_c2h_0 -f rx.bin -s $transferSize -c $transferCount 

