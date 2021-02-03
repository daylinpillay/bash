#!/bin/bash
#Folder=IT/
#authusers=/export/data/IT/.IT
#alert="email1, email2"

for id in `smbstatus -L |grep $Folder |gawk '{ print $2}'|uniq`
do
user_full_name=$(getent passwd $id | cut -d ':' -f 5)
user_fname=$(echo "$user_full_name" | cut -d ',' -f 2)
user_lname=$(echo "$user_full_name" | cut -d ',' -f 1)
username=$(getent passwd $id | cut -d ':' -f 1)

chk=$(grep -ci $username $authusers)
if [ "$chk" != "0" ]; then
echo "$user_fname $user_lname is Authorized to Access $Folder" >> /dev/null
exit 127
else
echo "$user_fname $user_lname has UnAuthorized to Access $Folder on `date`
