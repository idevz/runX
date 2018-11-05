FROM centos:7

ENV RUNX_VERSION 0.0.1

COPY / /tmp

WORKDIR /tmp

RUN set -ex; \
	\
	source ./init; \
	\
	init;
