FROM ubuntu:latest

RUN apt update && apt install -y ffmpeg handbrake-cli && apt clean

WORKDIR /app/
COPY ./output/ /app/

EXPOSE 8080

VOLUME /app/data

ENTRYPOINT ["/app/server", "--data-dir=/app/data", "--web-dir=/app/web"]