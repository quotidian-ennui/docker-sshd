FROM centos:centos7

EXPOSE 22

ARG ssh_user=user
ENV SSH_USERNAME=$ssh_user

RUN \
    yum -y update && \
    yum -y install openssh-server passwd sed sudo && \
    yum clean all && \
    mkdir -p /ssh.init.d && \
    curl -fsSL -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 && \
    chmod +x /usr/local/bin/dumb-init && \
    /usr/bin/ssh-keygen -A

COPY ./sshd_config /etc/ssh/sshd_config
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./.ssh /tmp/.ssh

RUN \
  chmod +x /docker-entrypoint.sh && \
  useradd ${SSH_USERNAME} && \
  mkdir -p /home/${SSH_USERNAME}/.ssh && \
  if [ -e /tmp/.ssh/authorized_keys ]; then cp /tmp/.ssh/authorized_keys /home/${SSH_USERNAME}/.ssh/authorized_keys; fi && \
  chown -R ${SSH_USERNAME}.${SSH_USER} /home/${SSH_USERNAME}/.ssh && \
  rm -rf /tmp/.ssh && \
  chmod -R go-rwx /home/${SSH_USERNAME}/.ssh

ENV SSH_USERNAME=""

VOLUME [ "/ssh.init.d" ]
ENTRYPOINT ["/docker-entrypoint.sh"]
