FROM centos:7

ARG debug

RUN set -x;\ 
    yum install -y make gcc gcc-c++ tree psmisc tcpdump;\
    yum install -y zsh net-tools which nmon;\
    rpm -e --nodeps systemd;\
    yum remove -y dracut* passwd* iputils* hostname*\
    rootfiles* acl* bind-license* cryptsetup-libs* \
    vim-minimal* dbus* kpartx* dbus-python* \
    kmod-libs* device-mapper* python-gobject-base* qrencode-libs*;\
    #git dbus*
    #sudo vim-minimal*
    yum install -y sudo;\
    yum install -y http://dl.fedoraproject.org/pub/epel/testing/7/x86_64/Packages/p/patchelf-0.9-10.el7.x86_64.rpm;\
    yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/n/nmon-16g-3.el7.x86_64.rpm;\
    [ ! -z "${debug}" ] && yum install -y systemtap systemtap-runtime;\
    yum autoremove -y ;\
    yum clean all ;\
    rm -rf /var/cache/yum;


FROM scratch
COPY --from=0 / /

CMD ["/bin/bash"]