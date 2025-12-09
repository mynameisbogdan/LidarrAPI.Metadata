# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.23

ARG COMMIT_HASH=''
ARG GIT_BRANCH=''

ENV COMMIT_HASH=$COMMIT_HASH \
    GIT_BRANCH=$GIT_BRANCH

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

USER root

WORKDIR /metadata
COPY --chown=0:0 --chmod=755 . /metadata

RUN set -x && \
    apk add -U --upgrade --virtual .build-deps \
      gcc \
      make \
      musl-dev && \
    pip --no-cache-dir install --upgrade pip setuptools && \
    pip --disable-pip-version-check --no-cache-dir install "poetry~=2.0" && \
    poetry install --only=main && \
    apk --purge del .build-deps && \
    rm -rf \
      /var/cache/apk/* \
      /var/cache/pypoetry/* \
      /tmp/*

USER nobody:nogroup

ENTRYPOINT ["lidarr-metadata-server"]
