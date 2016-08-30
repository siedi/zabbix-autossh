# zabbix-autossh

While running a Zabbix server at home using the nice https://github.com/monitoringartist/zabbix-xxl, I want it to connect to the agents on my public servers. To not expose the Zabbix agents to the internet, I run it only on the localhost interface. iptables would be an option, but my home IP is dynamic and changes from time to time. To make the connection between the Zabbix server and agents, I run an ssh tunnel, controled by autssh.

### Setup docker container

Clone Repository
```
git clone https://github.com/siedi/zabbix-autossh.git
```

Generate your own keys
```
ssh-keygen -t rsa -b 4096 -f ./id_rsa -C "your_email@example.com"
```

Build new image
```
docker build -t siedi/zabbix-autossh .
```

### Setup server with Zabbix agent

(borrowed from https://sathya.de/blog/how-tos/setup-zabbix-agent-through-ssh-tunnel-on-debian/)

Assuming you have already installed the zabbix-agent, e.g. with
```
aptitude install zabbix-agent
```

Edit /etc/zabbix/zabbix_agentd.conf and make the following changes
```
ListenIP=127.0.0.1
```

Add a new user we are using for the ssh tunnel
```
adduser --system --group zabbixagent
```

Copy the previously generated public key file id_rsa.pub to /home/zabbixagent/.ssh/authorized_keys

Set the right permissions
```
chown -R zabbixagent:zabbixagent /home/zabbixagent
chmod 440 /home/zabbixagent/.ssh/authorized_keys
```

### Run the container

Start the container and the ssh tunnel

```
docker run -d --name autossh-yourserver -t -i siedi/zabbix-autossh zabbixagent@yourserver.com -p 2222
```

Link that container in your Zabbix Server container, e.g. 
```
docker run \
    -d \
    --name zabbix \
    -p 8085:80 \
    -p 10051:10051 \
    -v /etc/localtime:/etc/localtime:ro \
    --link zabbix-db:zabbix.db \
    --link autossh-yourserver:yourserver \
    --env="ZS_DBHost=zabbix.db" \
    ....
    monitoringartist/zabbix-3.0-xxl:latest
```

### Add Agent to Zabbix

In the Zabbix server add the new host to your configuration. In the agent config of that host add "yourserver" as the DNS name. Port is default.

You can also add a discovery rule by scanning the IP range 172.17.0.1-254.
