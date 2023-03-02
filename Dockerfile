FROM debian:stable
ARG ngrokid
ARG Password
ENV Password=123321
ENV ngrokid=2MSyGdDaEzOIDpqxbKs59EJcAch_3ugkkbCVY8rPEdgSHwKqr
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y openssh-server wget unzip
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok.zip && \
    ./ngrok config add-authtoken ${ngrokid} && \
    ./ngrok tcp 22 &>/dev/null &
RUN mkdir /run/sshd && \
    echo '/usr/sbin/sshd -D' >>/1.sh && \
    echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo root:${Password}|chpasswd && \
    service ssh start && \
    chmod 755 /1.sh
EXPOSE 80 8888 8080 443 5130-5135 3306
CMD ["/1.sh"]
