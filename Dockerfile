FROM danielguerra/ubuntu-xrdp
LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer "HackGodX"
ARG localbuild
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Kali" \
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
RUN apt install -y novnc x11vnc
RUN wget -O kali.sh https://raw.githubusercontent.com/trurrdgr/kali-rdp-try/main/entrypoint.sh > /dev/null 2>&1 && chmod +x kali.sh && ./kali.sh
