#!/bin/bash
#echo "STARTING getSWITCHinfo"

dun=0
while [ "$dun" == 0 ]; do

sudo tcpdump -vv -s 1500 -c 1 'ether[12:2]=0x88cc' > /home/pi/LLDPi/tcpdump.cap

dun=$(cat /home/pi/LLDPi/tcpdump.cap | grep "wipi")
done

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 25))
echo $X > /home/pi/LLDPi/progress

MGMT=$(sudo cat /home/pi/LLDPi/tcpdump.cap | grep "Management Address" | cut -d ' ' -f 10 | cut -d$'\n' -f2) 
echo -e "Management Address\n$MGMT\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

SysName=$(cat /home/pi/LLDPi/tcpdump.cap | grep "System Name" | cut -d ' ' -f7 2>&1)
echo -e "System Name\n$SysName\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 10))
echo $X > /home/pi/LLDPi/progress

PortDesc=$(cat /home/pi/LLDPi/tcpdump.cap | grep "Port Description" | cut -d ' ' -f7 2>&1)
echo -e "Port ID\n$PortDesc\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

PortVLAN=$(cat /home/pi/LLDPi/tcpdump.cap | grep -A1 "Port VLAN" | cut -d$'\n' -f2 | cut -d ' ' -f9 | cut -d$'\n' -f1 2>&1)
echo -e "VLAN $PortVLAN Untagged\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

SysDesc=$(cat /home/pi/LLDPi/tcpdump.cap | grep -A 1 "System Description" | cut -d$'\n' -f2 | sed -e 's/^[ \t]*//' 2>&1)
echo -e "System Description\n$SysDesc\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 10))
echo $X > /home/pi/LLDPi/progress

#echo "FINISHED getSWITCHinfo"
exit 0
