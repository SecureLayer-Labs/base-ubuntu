# syntax=docker/dockerfile:1.7
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

# OCI labels (basic provenance metadata)
LABEL org.opencontainers.image.title="SecureLayer Labs Base Ubuntu"
LABEL org.opencontainers.image.description="Minimal Ubuntu base image for SecureLayer Labs secure image series"
LABEL org.opencontainers.image.source="https://github.com/SecureLayer-Labs/base-ubuntu"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV DEBIAN_FRONTEND=noninteractive

# Minimal packages most containers need:
# - ca-certificates: TLS
# - tzdata: avoids timezone prompts in some environments
# - tini: sane PID 1 behavior (optional but useful)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      tzdata \
      tini \
 && rm -rf /var/lib/apt/lists/*

# Create an unprivileged user (apps can switch to it)
RUN useradd -r -u 10001 -g root -m -d /home/app app \
 && mkdir -p /work \
 && chown -R 10001:0 /home/app /work \
 && chmod -R g=u /home/app /work

WORKDIR /work

# Default entrypoint uses tini to avoid zombie processes
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["bash","-lc","echo 'SecureLayer Labs base-ubuntu. Override CMD in your derived image.' && sleep 3600"]
