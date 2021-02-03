#!/bin/sh
# /etc/cron.daily/databack: daily backups script
# Western Inspection Ltd.
# Geoff Allan - July 29, 2010

# Start in the root filesystem
cd /

LOCKFILE=/var/lock/cron.daily
umask 022

#
# Avoid running more than one at a time
#

if [ -x /usr/bin/lockfile-create ] ; then
    lockfile-create $LOCKFILE
    if [ $? -ne 0 ] ; then
        cat <<EOF

Unable to run /etc/cron.daily/databack because lockfile $LOCKFILE
acquisition failed. This probably means that the previous day's
instance is still running. Please check and correct if necessary.

EOF
        exit 1
    fi

    # Keep lockfile fresh
    lockfile-touch $LOCKFILE &
    LOCKTOUCHPID="$!"
fi

#
# Backup key system files
#

if cd /backunit ; then

# copydir requires the package "mirrordir" and automatically determines
# if files are new, old, modified, etc, only copying the minimum amount
# to synch directories. Could also use "mirrordir" but that will delete
# files from backup if they were deleted from the main store.

copydir /etc                         /backunit/olympic/osbackup
copydir /var                         /backunit/olympic/osbackup

copydir /dataunit/Apps               /backunit/olympic/databackup
copydir /dataunit/Documents          /backunit/olympic/databackup
copydir "/dataunit/Document Storage" /backunit/olympic/databackup
copydir "/dataunit/Document Vault"   /backunit/olympic/databackup
copydir /dataunit/Management_Shared  /backunit/olympic/databackup
copydir /dataunit/Office_Shared      /backunit/olympic/databackup
# copydir /netlogon                    /backunit/olympic/databackup

# next step will be to pull data from britannic and titanic as required

# rsync -avz britannic:/etc            /backunit/britannic/osbackup
# rsync -avz britannic:/var            /backunit/britannic/osbackup

fi

#
# Clean up lockfile
#

if [ -x /usr/bin/lockfile-create ] ; then
    kill $LOCKTOUCHPID
    lockfile-remove $LOCKFILE
fi



