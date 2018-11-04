<<<<<<< HEAD
<<<<<<< HEAD
FROM idevz_centos:latest
=======
FROM centos:7
>>>>>>> 3d8a470... add dk and k8s init
=======
FROM idevz_centos:latest
>>>>>>> 3f4dc0c... update lua deploy

# ---------------- #
#     Building     #
# ---------------- #

LABEL maintainer="idevz <zhoujing00k@gmail.com>"
LABEL RUN="docker run -it --privileged --name NAME IMAGE"
<<<<<<< HEAD
<<<<<<< HEAD
ENV IN_DK=true
COPY / /tmp/

WORKDIR /tmp

RUN cd /tmp;\
    ls ;\
    source ./init;\
=======

=======
ENV IN_DK=true
>>>>>>> 3f4dc0c... update lua deploy
COPY / /tmp/

WORKDIR /tmp

<<<<<<< HEAD
RUN yum install -y sudo;\
    cd /tmp;\
    source /tmp/init;\
>>>>>>> 3d8a470... add dk and k8s init
=======
RUN cd /tmp;\
    ls ;\
    source ./init;\
>>>>>>> 3f4dc0c... update lua deploy
    init;
