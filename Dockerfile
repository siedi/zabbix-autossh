# autossh
#
# VERSION               0.0.1

FROM alpine
MAINTAINER siedi <matthias@siedler.com>

# Adding ssh key
RUN mkdir -p /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa

# Installing autossh
RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade \
 && apk -U --no-progress add autossh@edge \
 && rm -rf /var/lib/apt/lists/*

# Our start script
ADD autossh-start.sh /autossh-start.sh
RUN chmod +x /autossh-start.sh

# Standard Zabbix Agent Port
EXPOSE 10050

VOLUME /root/.ssh/id_rsa

ENTRYPOINT ["/autossh-start.sh"]
