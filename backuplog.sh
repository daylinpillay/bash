ls -al --full-time olympic-home.$(date -d '1 day ago' +"%Y%m%d").master.tar.gz |awk '{print $9",",$5,",",$6,",",$7}' >> /root/scripts/backuplogs/"$(date -d '1 day ago' +"%Y%m%d").csv"
