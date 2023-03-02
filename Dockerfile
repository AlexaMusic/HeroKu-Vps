FROM alpine:3.12
RUN apk add --no-cache curl && \
    curl -sSL https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o /tmp/ngrok.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin && \
    rm /tmp/ngrok.zip
ARG AUTH_TOKEN
ARG PASSWORD

RUN echo "auth_token: ${AUTH_TOKEN}" >> /root/.ngrok2/ngrok.yml && \
    echo "http_auth: ${PASSWORD}" >> /root/.ngrok2/ngrok.yml
EXPOSE 4040
CMD ["ngrok", "start", "--config", "/root/.ngrok2/ngrok.yml", "--all"]
