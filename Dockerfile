FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ARG TARGETOS
ARG TARGETARCH
ARG VERSION

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl bzip2

RUN set -x                                                                                                                                 \
  && curl -fsSL -o restic.bz2 https://github.com/restic/restic/releases/download/v${VERSION}/restic_${VERSION}_${TARGETOS}_${TARGETARCH}.bz2 \
  && bzip2 -d restic.bz2                                                                                                                   \
  && chmod 755 restic



FROM busybox

ARG TARGETOS
ARG TARGETARCH
ARG VERSION

LABEL org.opencontainers.image.source https://github.com/stashed/restic-docker

COPY --from=0 /restic /bin/restic
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/bin/restic"]
