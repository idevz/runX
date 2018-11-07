FROM idevz_centos:latest

# ---------------- #
#     Building     #
# ---------------- #

LABEL maintainer="idevz <zhoujing00k@gmail.com>"
LABEL RUN="docker run -it --privileged --name NAME IMAGE"
ENV IN_DK=true
COPY / /tmp/

WORKDIR /tmp

RUN cd /tmp;\
    ls ;\
    source ./init;\
    init;
