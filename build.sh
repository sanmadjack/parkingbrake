#!/bin/sh

cd server
dart pub get
dart compile
dart2native bin/server.dart -o bin/server
cd ../gui
dart pub get
flutter build web --release