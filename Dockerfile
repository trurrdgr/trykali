FROM kalilinux/kali-last-release
LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer "HackGodX"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Ubuntu_Desktop" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1920x1080" \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token (It's advisable to use your personal token, else it may clash with other users & your tunnel may get terminated)
	NGROK_TOKEN="1tNm3GUFYV1A4lQFXF1bjFvnCvM_4DjiFRiXKGHDaTGBJH8VM" \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Kolkata"

RUN apt-get update \
    && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && echo 'root:kali' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
COPY . /app
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install x11vnc && \
	apt-get install firefox-esr && \
	apt-get install -y \
#Fluxbox
	/app/fluxbox-heroku-mod.deb && \
#MATE Desktop
	#apt install -y \ 
	#ubuntu-mate-core \
	#ubuntu-mate-desktop && \
#XFCE Desktop
	#apt install -y \
	#xubuntu-desktop && \
#TimeZone
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
#NoVNC
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
	openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert
	
ENTRYPOINT ["supervisord", "-c"]

CMD ["/app/supervisord.conf"]
