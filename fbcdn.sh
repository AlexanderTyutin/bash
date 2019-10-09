#!/bin/bash

for i in `cat /var/log/squid/access.log | grep fbcdn | cut -d '/' -f 3 | cut -d ' ' -f 1 | sort | uniq | grep [0-9]`;
        INETNUM=$(whois $i | grep -m 1 'inetnum\|NetRange' | cut -d ':' -f 2)
        CIDR=$(ipcalc $INETNUM | grep /)
        #echo IP: $i INETNUM: $INETNUM CIDR: $CIDR
        echo $i\;$INETNUM\;$CIDR >> /home/proxyadmin/qos_content/$(date +%Y%m%d)fbcdnip_full
done


for j in `cat ~/qos_content/$(date +%Y%m%d)fbcdnip_full | cut -d ';' -f 3 | sort | uniq`; do
        IP=$(echo $j | cut -d '/' -f 1)
        COMMENT=$(whois $IP | grep -m 1 'netname\|NetName\|descr\|Descr' | cut -d ':' -f 2)
        #echo $j\;$COMMENT
        echo $j\;$COMMENT >> ~/qos_content/$(date +%Y%m%d)fbcdnip_comment
        echo $j >> ~/qos_content/$(date +%Y%m%d)fbcdnip
        echo :do {/ip firewall address-list add list=QOS_CDN address=$j comment=\"fbcdn $COMMENT\"} on-error={} >> /h
done
