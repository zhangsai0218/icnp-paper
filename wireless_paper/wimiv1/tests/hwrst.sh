#/bin/bash
echo 1 | sudo tee /sys/bus/pci/devices/0000:04:00.0/remove
read -p "Download bit file then press any key to continue" a
echo 1 | sudo tee /sys/bus/pci/rescan
./load_driver.sh

