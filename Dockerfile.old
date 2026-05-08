FROM archlinux:latest


RUN pacman -Sy --noconfirm ffmpeg handbrake-cli unzip git which curl wget
ENV PATH="${PATH}:/build/flutter/bin"

WORKDIR /build
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.41.7-stable.tar.xz
RUN tar -xf flutter_linux_*.tar.xz -C /build
RUN git config --global --add safe.directory /build/flutter
RUN /build/flutter/bin/flutter config --enable-web

WORKDIR /build/gui

COPY gui/pubspec.yaml /build/gui/pubspec.yaml

RUN /build/flutter/bin/dart pub get

WORKDIR /build/server

COPY server/pubspec.yaml /build/server/pubspec.yaml

RUN /build/flutter/bin/dart pub get

WORKDIR /build/gui

COPY gui/ /build/gui
RUN mkdir /app 
RUN mkdir /app/web 

RUN /build/flutter/bin/flutter build web --release --output=/app/web/ && cd / && rm /build/gui -R

WORKDIR /build/server

COPY server/ /build/server
RUN /build/flutter/bin/dart compile exe bin/server.dart -o /app/server && cd / && rm /build -R

EXPOSE 8080

VOLUME /app/data

ENTRYPOINT ["/app/server", "--data-dir=/app/data", "--web-dir=/app/web"]