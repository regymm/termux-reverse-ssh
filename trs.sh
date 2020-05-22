#!/data/data/com.termux/files/usr/bin/bash
# termux-reverse-ssh by ustcpetergu
# License: GPLv3
. ~/.trs_config
if [[ "$?" != "0" ]]; then
    echo "Error loading config file. "
    exit 255
fi

# launch termux sshd (port 8022)
sshd &

checktime=1800

while true; do
    # trigger if URL becomes exist
    wget $url -O - > /dev/null 2>&1
    triggered=$?
    if [[ "$triggered" == "0" ]]; then
        echo "Trigger!"
        ssh -i $idrsa -R 2333:localhost:8022 ${user}@${address}
        # start a new loop in case of exit
        # remove URL to stop trigger
    else
        echo "Wait..."
        sleep $checktime
    fi
done

