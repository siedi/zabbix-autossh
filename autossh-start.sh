#!/bin/sh

if [ $# -eq 0 ]; then
    echo -e "No parameters given\nHostname for ssh is missing. E.g. 'zabbixagent@myhost.de -p 2222'"
    exit 1
fi

if [ ! -r /root/.ssh/id_rsa ]; then
  echo -e "No RSA key /root/.ssh/id_rsa found "
  echo -e "Mount the key from you host by adding -v /path/to/your/id_rsa:/root/.ssh/id_rsa"
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
