#!/usr/local/bin/dumb-init /bin/sh
/usr/bin/ssh-keygen -A
useradd user
SSH_USERPASS=$(head -c 10 /dev/urandom | sha256sum | cut -c1-10)
echo "user:$SSH_USERPASS" | chpasswd
# echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin user)
echo ssh user password: $SSH_USERPASS
exec /usr/sbin/sshd -D
