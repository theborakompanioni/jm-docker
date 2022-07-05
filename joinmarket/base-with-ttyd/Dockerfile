
# global arguments
ARG MAINTAINER='tbk'

ARG TTYD_REPO=https://github.com/tsl0922/ttyd.git
ARG TTYD_REPO_BRANCH=main
ARG TTYD_REPO_REF=1.6.3

# --- Builder base 
FROM alpine:3.15 AS builder-base
RUN apk add --no-cache --update git
# --- Builder base - end

# --- SERVER builder
FROM builder-base AS server-builder
ARG TTYD_REPO
ARG TTYD_REPO_BRANCH
ARG TTYD_REPO_REF

WORKDIR /usr/src/ttyd

RUN git clone "$TTYD_REPO" . --depth=1 --branch "$TTYD_REPO_BRANCH" \
    && git fetch --all --tags \
    && git checkout "$TTYD_REPO_REF"
# --- SERVER builder - end

FROM theborakompanioni/jmui-local-joinmarket/base:latest

RUN apt-get update \
    && apt-get install -qq --no-install-recommends cmake libjson-c-dev libwebsockets-dev \
    && rm -rf /var/lib/apt/lists/*

COPY supervisor-conf/*.conf /etc/supervisor/conf.d/

COPY --from=server-builder /usr/src/ttyd /opt/ttyd
RUN cd /opt/ttyd && mkdir build && cd build && cmake .. && make && make install

ENTRYPOINT  [ "tini", "-g", "--", "/docker-entrypoint.sh" ]
