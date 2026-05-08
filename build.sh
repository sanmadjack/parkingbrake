#!/bin/sh
set -e
VERSION=$(yq '.version' server/pubspec.yaml)
VERSION=$(echo "$VERSION" | tr -d '"')
echo "Building version $VERSION"

echo "Removing output folder"
rm -rf output

echo "Creating output folder"
mkdir -p output
mkdir -p output/web

echo "Building server"
cd server
dart pub get
dart compile exe bin/server.dart -o ../output/server

echo "Building gui"
cd ../gui
dart pub get
flutter build web --release --output=../output/web/ 

cd ..

echo "Building docker image"
docker build --progress=plain -t "parkingbrake:$VERSION" .

docker tag "parkingbrake:$VERSION" "sanmadjack/parkingbrake:$VERSION"
docker tag "parkingbrake:$VERSION" "sanmadjack/parkingbrake:latest"

docker push "sanmadjack/parkingbrake:$VERSION"
docker push sanmadjack/parkingbrake:latest
