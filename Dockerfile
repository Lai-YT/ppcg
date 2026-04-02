FROM ubuntu:22.04

# Install dependencies for building PPCG from source.
# Ubuntu 22.04 has llvm-14 in its repositories, which is the latest version supported by PPCG.
# Among those documented in the README, we also need llvm-14-dev and clang.
RUN apt-get update && apt-get install -y --no-install-recommends \
  automake autoconf libtool pkg-config libgmp3-dev libyaml-dev libclang-dev llvm-14-dev clang \
  build-essential ca-certificates git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# LLVM tools are installed with the version number in the name.
# Make them available without the version number.
RUN for tool in llvm-config; do \
  update-alternatives --install "/usr/bin/$tool" "$tool" "$(llvm-config-14 --bindir)/$tool" 140; \
  done

WORKDIR /opt/ppcg
COPY . /opt/ppcg

# Build PPCG from source.
RUN ./get_submodules.sh \
  && ./autogen.sh \
  && ./configure \
  && make -j"$(nproc)" \
  && find -name '*.o' -delete

# Make the container behave like the ppcg executable.
ENTRYPOINT ["/opt/ppcg/ppcg"]
