ARG TREKKER_VERSION=1.0.0-rc1

FROM ubuntu:focal AS builder

ARG TREKKER_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
                    build-essential \
                    cmake \
                    git \
                    zlib1g-dev

COPY . /opt/staging

RUN cd /opt/staging && \
    ./build.sh v${TREKKER_VERSION}


FROM ubuntu:focal

ARG TREKKER_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                    less \
                    libgomp1 \
                    zlib1g-dev

COPY --from=builder /opt/staging/build/trekker/install/bin/trekker /usr/bin/trekker

# Wrapper script to run Trekker - sets number of threads to a safe value if not specified
COPY --from=builder /opt/staging/run_trekker.sh /opt/bin/run_trekker.sh

ENV PATH="/opt/bin:${PATH}"

# Add a non-root user
RUN useradd -m trekker

USER trekker

LABEL maintainer="Philip A Cook" \
      description="This is a Docker container for Trekker https://dmritrekker.github.io/index.html" \
      trekker_version="${TREKKER_VERSION}"

ENTRYPOINT ["/opt/bin/run_trekker.sh"]
