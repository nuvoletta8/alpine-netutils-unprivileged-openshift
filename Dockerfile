FROM alpine:latest

LABEL maintainer="nuvoletta8@ymail.com"

RUN apk update

RUN apk add bash \
	bash-completion \
	busybox-extras \
	vim \
	curl \
	nmap \
	wget \
	network-extras \
        git \
        openssl \
        dumb-init

RUN echo "alias telnet='busybox-extras telnet'" > /etc/profile.d/telnet #Alias telnet command
RUN rm -fr /var/cache/apk/*

#Adding dir for mounting a volume
RUN mkdir /mnt/volume

RUN adduser -u 1001 -s /bin/sh -D -G root user
#Support Arbitrary User ID on folder /mnt/volume
RUN chgrp -R 0 /mnt/volume && chmod -R g=u /mnt/volume

COPY uid_entrypoint.sh /usr/local/bin/uid_entrypoint.sh
RUN chmod +x /usr/local/bin/uid_entrypoint.sh
COPY maintain.sh /usr/local/bin/maintain.sh
RUN chmod +x /usr/local/bin/maintain.sh

RUN chmod g=u /etc/passwd
ENTRYPOINT [ "uid_entrypoint.sh" ]
ENTRYPOINT [ "maintain.sh" ]
USER 1001

VOLUME /mnt/volume
