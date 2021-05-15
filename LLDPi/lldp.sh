#!/bin/bash

echo '0' > /home/pi/LLDPi/progress
echo > /home/pi/LLDPi/displayLLDP.txt
###echo -e "DISPLAYING LLDP INFORMATION\n" >> /home/pi/LLDPi/displayLLDP.txt
#echo "Running lldp script..."

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 1))
echo $X > /home/pi/LLDPi/progress

#making sure required tools are installed

#echo "checking if tshark, tcpdump, ethtool, and gawk are installed..."

if ! [ -x "$(type -P ethtool)" ]; then 
echo "please make sure ethtool is installed" >> /home/pi/LLDPi/displayLLDP.txt
exit 1
fi

if ! [ -x "$(type -P tshark)" ]; then 
echo "please make sure tshark is installed" >> /home/pi/LLDPi/displayLLDP.txt
exit 1
fi

if ! [ -x "$(type -P tcpdump)" ]; then
echo "please make sure tcpdump is installed" >> /home/pi/LLDPi/displayLLDP.txt
exit 1
fi

if ! [ -x "$(type -P gawk)" ]; then
echo "please make sure gawk is installed" >> /home/pi/LLDPi/displayLLDP.txt
exit 1
fi


X=$(< /home/pi/LLDPi/progress)
X=$(($X + 2))
echo $X > /home/pi/LLDPi/progress

# start tcpdump capture script in background, getSWITCHinfo
/home/pi/LLDPi/getSWITCHinfo.sh &
proc1=$!

# start tshark capture script in background, getVLANinfo
/home/pi/LLDPi/getVLANinfo.sh s 10 $proc1 &
proc2=$!

#waits for getVLANinfo.sh and getSWITCHinfo.sh to finish
wait $proc1
wait $proc2

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 2))
echo $X > /home/pi/LLDPi/progress

# writes current IP address to file
IP=$(ip a | gawk --re-interval '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/{print $0}' | cut -d ' ' -f 6 | cut -d '/' -f 1)
ethtool eth0 | grep "Link detected" | grep "yes" > /dev/null

if [ $? == '0' ];then

IP=$(echo $IP | cut -d ' ' -f 2)
echo -e "Raspberry IP Address\n$IP\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

Speed=$(ethtool eth0 | grep "Speed" | cut -d ' ' -f 2)

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 5))
echo $X > /home/pi/LLDPi/progress
else

IP=$(echo $IP | cut -d ' ' -f 1)
echo -e "Raspberry Pi IP Address\n$IP\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

Speed="0Mb/s"

##################################
X=$(< /home/pi/LLDPi/progress)
X=$(($X + 5))
echo $X > /home/pi/LLDPi/progress
#echo '100' > /home/pi/LLDPi/progress
#exit 1
##################################

fi

echo -e "Speed\n$Speed\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

# grabs default gateway IP address
DEFGW=$(route -n | grep G | cut -d $'\n' -f2 | awk '{print $2}')
echo -e "Default Gateway\n$DEFGW\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt
X=$(< /home/pi/LLDPi/progress)
X=$(($X + 7))
echo $X > /home/pi/LLDPi/progress

# grabs DNS servers IP addresses from /etc/resolv.conf and writes it to file
DNSSERVERS=$(sudo cat /etc/resolv.conf | grep nameserver | cut -d ' ' -f2)
echo -e "DNS Servers\n$DNSSERVERS\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt
X=$(< /home/pi/LLDPi/progress)
X=$(($X + 13))
echo $X > /home/pi/LLDPi/progress

# grabs current time and writes it to file
DATE=`date`
echo -e "DATE\n$DATE" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

echo '100' > /home/pi/LLDPi/progress
exit 0
