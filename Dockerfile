FROM kalilinux/kali-last-release
LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer "HackGodX"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="thanfees" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="HackGodx" \
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

COPY . /app
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server
RUN apt-get install -y x11vnc
RUN apt-get install -y x11vnc novnc
RUN apt-get install -y firefox-esr
RUN apt install -y kali-desktop-xfce
RUN apt-get install -y \
#Packages Installation
	tzdata \
	software-properties-common \
	apt-transport-https \
	wget \
	git \
	curl \
	vim \
	zip \
	net-tools \
	iputils-ping \
	build-essential \
	python3 \
	python3-pip \
	python-is-python3 \
	perl \
	ruby \
	golang \
	lua5.3 \
	scala \
	mono-complete \
	r-base \
	default-jre \
	default-jdk \
	clojure \
	php \
	firefox-esr \
	gnome-terminal \
	gnome-calculator \
	gnome-system-monitor \
	gedit \
	vim-gtk3 \
	mousepad \
	libreoffice \
	pcmanfm \
	snapd \
	terminator \
	websockify \
	supervisord \
	x11vnc \
	xvfb \
	gnupg \
	dirmngr \
	gdebi-core \
	nginx \
	openvpn \
	ffmpeg \
	pwgen \
	screen
RUN apt-get install -y \
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
