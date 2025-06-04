FROM golang:latest as builder

ARG ACE_INSTALL
WORKDIR /opt/ibm
COPY deps/$ACE_INSTALL .

RUN mkdir ace-12
RUN tar -xzf $ACE_INSTALL --absolute-names \
    --exclude ace-12.\*/server/bin/TADataCollector.sh \
    --exclude ace-12.\*/server/transformationAdvisor/ta-plugin-ace.jar \
    --strip-components 1 \
    --directory /opt/ibm/ace-12

FROM centos:8

WORKDIR /opt/ibm

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo

RUN yum -y update && \
    yum install -y xorg-x11-server-Xvfb gtk3 libXtst && \
    yum clean all

COPY --from=builder /opt/ibm/ace-12 /opt/ibm/ace-12

RUN /opt/ibm/ace-12/ace make registry global accept license silently 

COPY mqsicreatebar.sh /usr/bin/mqsicreatebar.sh

ENTRYPOINT [ "/usr/bin/mqsicreatebar.sh" ]
