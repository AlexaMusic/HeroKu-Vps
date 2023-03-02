FROM debian:stable
RUN apt-get update -y > /dev/null 2>&1 && \
    apt-get upgrade -y > /dev/null 2>&1 && \
    apt-get install -y --no-install-recommends openssh-server wget unzip > /dev/null 2>&1 && \
    rm -rf /var/lib/apt/lists/*
ARG ngrokid
ARG Password
ENV Password=${Password}
ENV ngrokid=${ngrokid}
RUN wget -O /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1 && \
    unzip /ngrok.zip -d /bin && \
    rm /ngrok.zip
RUN echo "/bin/ngrok authtoken ${ngrokid}" >> /entrypoint.sh && \
    echo "/bin/ngrok tcp 22 &>/dev/null &" >> /entrypoint.sh && \
    echo "mkdir -p /run/sshd && /usr/sbin/sshd -D" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    echo "PrintMotd no" >> /etc/ssh/sshd_config && \
    echo "AcceptEnv LANG LC_*" >> /etc/ssh/sshd_config && \
    echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config && \
    echo "UseDNS no" >> /etc/ssh/sshd_config
RUN useradd -ms /bin/bash sshuser && \
    echo "sshuser:${Password}" | chpasswd && \
    usermod -aG sudo sshuser && \
    echo "sshuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
