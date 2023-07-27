FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y software-properties-common apt-utils
RUN add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" && apt update
RUN apt-get -y install   ca-certificates \
                         dbus-x11 \
                         libx11-6 \
                         libx11-xcb1 \
                         libfontconfig1 \
                         sudo \
                         supervisor \
                         openbox \
                         xauth \
                         xautolock \
                         xfce4 \
                         xfce4-screensaver \
                         xvfb \
                         x11vnc \ 
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*

RUN apt update && apt install -y wget cabextract xfonts-utils net-tools uuid-runtime xdg-utils zenity libgconf-2-4 fonts-wqy-zenhei
RUN wget https://download.screamingfrog.co.uk/products/seo-spider/screamingfrogseospider_19.0_all.deb; \
    apt --fix-broken install -y ./screamingfrogseospider_19.0_all.deb; 


RUN echo "set convert-meta off" >> /etc/inputrc
RUN echo "xfce4-session" > /etc/skel/.Xclients
RUN addgroup ubuntu
RUN useradd -m -s /bin/bash -g ubuntu ubuntu
RUN echo "ubuntu:ubuntu" | /usr/sbin/chpasswd
RUN echo "ubuntu    ALL=(ALL) ALL" >> /etc/sudoers
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir /var/log/supervisor
RUN mkdir /var/run/dbus
COPY bin /bin
# RUN mv /usr/bin/Xorg /usr/bin/Xorg-orig ; mv  /usr/bin/X /usr/bin/X-orig ; cp /usr/bin/Xvfb /usr/bin/Xorg; cp /usr/bin/Xvfb /usr/bin/X

ENV DISPLAY :0

EXPOSE 5900

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["supervisord"]

