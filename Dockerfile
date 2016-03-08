FROM centos:7
MAINTAINER levkov

RUN rm -f /etc/localtime && ln -sf /usr/share/zoneinfo/UTC /etc/localtime
RUN yum update -y
RUN rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y python-pip
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y nginx
RUN pip install supervisor requests==2.5.3

RUN groupadd -r siteop && useradd -r -g siteop siteop && \
    echo 'root:ContaineR' | chpasswd

RUN rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM yes/g" /etc/ssh/sshd_config

COPY conf/supervisord.conf /etc/supervisord.conf
COPY html/index.html /usr/share/nginx/html/index.html

EXPOSE 9001 22 80
CMD ["/usr/bin/supervisord"]
