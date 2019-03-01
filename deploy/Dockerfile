FROM centos:7

MAINTAINER idevz zhoujing00k@gmail.com
LABEL RUN='docker run -it --privileged --name NAME IMAGE'

ARG PROJ
ARG BUILD_ENV

COPY ./build-images.sh /build-images.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./docker-build-run-path/${PROJ}/ /runX/${PROJ}/
RUN /build-images.sh

ENTRYPOINT [ "/entrypoint.sh" ]
