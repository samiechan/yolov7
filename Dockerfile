# Based on ultralytics/yolov5 - https://github.com/ultralytics/yolov5/blob/master/utils/docker/Dockerfile-cpu
# YOLOv7 🚀, GPL-3.0 license
# Builds xrockamy/yolov7:latest-cpu image on DockerHub https://hub.docker.com/r/ultralytics/yolov5
# Image is CPU-optimized for ONNX, OpenVINO and PyTorch YOLOv7 deployments

# Start FROM Ubuntu image https://hub.docker.com/_/ubuntu
FROM ubuntu:20.04

# Downloads to user config dir
ADD https://ultralytics.com/assets/Arial.ttf https://ultralytics.com/assets/Arial.Unicode.ttf /root/.config/Ultralytics/

# Install linux packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN TZ=Etc/UTC apt install -y tzdata
RUN apt install --no-install-recommends -y python3-pip git zip curl htop libgl1-mesa-glx libglib2.0-0 libpython3-dev gnupg
# RUN alias python=python3

# Install pip packages
COPY requirements.txt .
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -r requirements.txt ultralytics albumentations gsutil notebook \
    coremltools onnx onnx-simplifier onnxruntime tensorflow-cpu tensorflowjs \
    # openvino-dev \
    --extra-index-url https://download.pytorch.org/whl/cpu

# Create working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy contents
# COPY . /usr/src/app  (issues as not a .git directory)
RUN git clone https://github.com/samiechan/yolov7 /usr/src/app
ENV DEBIAN_FRONTEND teletype


# Usage Examples -------------------------------------------------------------------------------------------------------

# Build and Push
# t=xrockamy/yolov7:latest-cpu && sudo docker build -f utils/docker/Dockerfile-cpu -t $t . && sudo docker push $t

# Pull and Run
# t=xrockamy/yolov7:latest-cpu && sudo docker pull $t && sudo docker run -it --ipc=host -v "$(pwd)"/datasets:/usr/src/datasets $t