FROM centos:7

# ---------------- #
#     Building     #
# ---------------- #

LABEL maintainer="idevz <zhoujing00k@gmail.com>"
LABEL RUN="docker run -it --privileged --name NAME IMAGE"

COPY / /tmp/
COPY /bin/sudo /bin/sudo
COPY /bin/make /bin/make

WORKDIR /tmp

RUN yum install -y sudo;\
    cd /tmp;\
    source /tmp/init;\
    init;
