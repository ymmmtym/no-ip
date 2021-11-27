#!/usr/bin/env sh

CONFIG_FILE=no-ip2.conf

function ts {
    echo [`date '+%b %d %X'`]
}

function serve {
    while true
    do
    noip2 -c $CONFIG_FILE
    sleep 5

        while true
        do
            output=$(noip2 -S -c $CONFIG_FILE 2>&1)
            if [[ "$output" != *"active"* ]]; then
                echo "$(ts) ERROR: noip2 has stopped running. Restarting it in 60 seconds."
                sleep 60
                break
            fi
            echo "$(ts) $output"
            sleep 60
        done
    done
}

function test {
    noip2 -c $CONFIG_FILE
    sleep 5
    noip2 -S -c $CONFIG_FILE
}

#------------ main ----------------#

noip2 -u $USERNAME -p $PASSWORD -U ${INTERVAL:-30} -C -c $CONFIG_FILE

case $1 in
    "test")test
        ;;
    "serve")serve
        ;;
    *)serve
        ;;
esac
