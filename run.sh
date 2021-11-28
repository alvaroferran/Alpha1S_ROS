#!/bin/bash

VOLUME_SRC="$(pwd)/src/"
VOLUME_DST="/root/dev_ws/"
CONTAINER="alpha1s"
IMAGE="alpha1s_ros"
IMAGE_VERSION="foxy"
IMAGE_FULL="$IMAGE:$IMAGE_VERSION"

# Allow container to access X server
xhost +local:root 

# Start new container shell if running
if [ "$(docker container list | grep "$CONTAINER")" ]; then
    docker exec -it "$CONTAINER" bash
    exit 0
fi

# Start container if it exists but not running
if [ "$(docker container list -a | grep "$CONTAINER")" ]; then
    docker start "$CONTAINER" && docker attach "$CONTAINER"
    exit 0
fi

# Build image if Dockerfile is modified
docker build --build-arg ROS_DISTRO=${IMAGE_VERSION} --rm -t "$IMAGE_FULL" .

# Create container if it doesn't exist
docker run \
    --name $CONTAINER \
    --env DISPLAY=$DISPLAY \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --workdir=$VOLUME_DST \
    --volume $VOLUME_SRC:$VOLUME_DST/src \
    --volume /dev/bus/usb:/dev/bus/usb --privileged \
    --net=host \
    -it $IMAGE_FULL
