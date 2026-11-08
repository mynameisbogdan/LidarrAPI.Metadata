# syntax=docker/dockerfile:1

FROM mirror.gcr.io/python:3.13-alpine3.24@sha256:1e1f6334529d1fb26a2ef619d7cffb30a7c7d7cc1cc7338ebee283a58d1aeaca

ARG COMMIT_HASH=''
ARG GIT_BRANCH=''

ENV COMMIT_HASH=$COMMIT_HASH \
    GIT_BRANCH=$GIT_BRANCH

USER root
WORKDIR /app

COPY --chown=0:0 --chmod=755 . /app

RUN --mount=type=bind,from=ghcr.io/astral-sh/uv:0.13.7@sha256:96f40d3904aad8d0bd010539001d36c8e2188b981e1334471a90c4a1d93bb490,source=/uv,target=/usr/local/bin/uv \
    set -eux; \
    apk add --no-cache --upgrade \
        ca-certificates; \
    uv build --no-cache --wheel; \
    uv pip install --system dist/*.whl; \
    chown -R root:root /app; \
    chmod -R 755 /app; \
    rm -rf /root/.cache /var/log/* /tmp/*;

USER nobody:nogroup

ENTRYPOINT ["lidarr-metadata-server"]
