FROM nvidia/cuda:12.1.0-base-ubuntu18.04

RUN apt-get update && apt-get install -y \
  automake \
  autoconf \
  libtool \
  pkg-config \
  libgmp3-dev \
  libyaml-dev \
  libclang-dev \
  llvm \
  clang \
  git \
  make
