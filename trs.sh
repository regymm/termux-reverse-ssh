#!/data/data/com.termux/files/usr/bin/bash
# termux-reverse-ssh by ustcpetergu
# License: GPLv3

isdebug=1
function loggen() {
    if [[ $isdebug -ne 0 ]]; then
        log -t trs -p $1 "$2"
        echo -e "$2"
    fi
}

. ~/.trs_config
if [[ "$?" != "0" ]]; then
    loggen e "Error loading config file. "
    exit 255
fi

echo $$ > ~/.trs_pid

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

