# syntax=docker/dockerfile:1

FROM mirror.gcr.io/python:3.13-alpine3.24@sha256:bf12ecc0bea3f171d55145dd02c78b5eeb09f30ee2ac9cc2b4c9e4e8f5e30741

ARG COMMIT_HASH=''
ARG GIT_BRANCH=''

ENV COMMIT_HASH=$COMMIT_HASH \
    GIT_BRANCH=$GIT_BRANCH

USER root
WORKDIR /app

COPY --chown=0:0 --chmod=755 . /app

RUN --mount=type=bind,from=ghcr.io/astral-sh/uv:0.13.6@sha256:af22a52f5eafef3d78e551599d405c02df61919d18028f0cea8eda93bc9986d0,source=/uv,target=/usr/local/bin/uv \
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
