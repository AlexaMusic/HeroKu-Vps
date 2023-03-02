FROM python:3.9-slim-buster
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y curl
RUN curl -L https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o ngrok.zip && \
    unzip ngrok.zip && \
    rm ngrok.zip && \
    chmod +x ngrok
EXPOSE 4040
CMD ["./ngrok", "authtoken", "2MSyGdDaEzOIDpqxbKs59EJcAch_3ugkkbCVY8rPEdgSHwKqr", "http", "5000"]
