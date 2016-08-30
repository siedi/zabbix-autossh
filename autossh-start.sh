#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "Hostname is missing. E.g. 'zabbixagent@myhost.de -p 2222'"
    exit 1
fi
 
autossh -M 20050 \
 -N \
 -o StrictHostKeyChecking=no \
 -o ServerAliveInterval=5 \
 -o ServerAliveCountMax=1 \
 -i /root/.ssh/id_rsa \
 -L *:10050:localhost:10050 \
 "$@"
