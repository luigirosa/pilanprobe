#!/bin/bash
#echo "STARITNG getVLANinfo"
#touch tshark.cap

if [ $1 == s ]; then
echo -e "capturing packets for $2 seconds"
sudo tshark -a duration:$2 -w /home/pi/LLDPi/tshark.cap &>/dev/null && wait
X=$(< /home/pi/LLDPi/progress)
X=$(($X + 17))
echo $X > /home/pi/LLDPi/progress

elif [ $1 == p ]; then
echo -e "capturing $2 packets"
sudo tshark -c $2 -w /home/pi/LLDPi/tshark.cap &>/dev/null && wait
X=$(< /home/pi/LLDPi/progress)
X=$(($X + 17))
echo $X > /home/pi/LLDPi/progress

else
echo "Something went wrong in packet capture for VLANs..."
exit 1
fi

if [ $# == 3 ]; then

while kill -0 $3 2> /dev/null; do
sleep 1;
done

fi

VLANS=$(sudo tshark -r /home/pi/LLDPi/tshark.cap -T fields -e vlan.id | sort -n -u | sed -n '1!p')
VLANS=$(echo "$VLANS" | awk '{print $0 " - Tagged"}')

echo -e "VLANs captured: $VLANS\n" 2>&1 | tee -a /home/pi/LLDPi/displayLLDP.txt

X=$(< /home/pi/LLDPi/progress)
X=$(($X + 8))
echo $X > /home/pi/LLDPi/progress

exit 0
