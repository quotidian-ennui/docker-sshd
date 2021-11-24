#!/usr/local/bin/dumb-init /bin/sh

USERNAME=user

function _init_users()
{
  useradd "$USERNAME"
  SSH_USERPASS=$(head -c 10 /dev/urandom | sha256sum | cut -c1-10)
  echo "$USERNAME:$SSH_USERPASS" | chpasswd
  echo ssh $USERNAME password: $SSH_USERPASS
}

function _init_user_ssh() {
  mkdir -p /home/$USERNAME/.ssh
  cp /home/ssh_resources/authorized_keys /home/$USERNAME/.ssh/authorized_keys
  chown -R $USERNAME.$USERNAME /home/$USERNAME/.ssh
  chmod -R go-rwx /home/$USERNAME/.ssh
}


_init_users
_init_user_ssh
/usr/bin/ssh-keygen -A
exec /usr/sbin/sshd -D
