
FROM centos:centos7

EXPOSE 22

RUN \
    yum -y update && \
    yum -y install openssh-server passwd sed sudo && \
    yum clean all && \
    curl -fsSL -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && \
    chmod +x /usr/local/bin/dumb-init

COPY ./sshd_config /etc/ssh/sshd_config
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
