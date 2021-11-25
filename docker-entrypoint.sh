#!/usr/local/bin/dumb-init /bin/bash

set -eo pipefail
shopt -s nullglob

USERNAME=${SSH_USERNAME:="user"}
SSH_USERPASS=${SSH_PASSWORD:="$(head -c 10 /dev/urandom | sha256sum | cut -c1-10)"}

function docker_process_init_files() {
	local f
	for f; do
		case "$f" in
			*.sh)
				if [ -x "$f" ]; then
					echo "$0: running $f"
					"$f"
				else
					echo "$0: sourcing $f"
					. "$f"
				fi
				;;
			*) ;;
		esac
	done
}

function _reset_password()
{
  echo "$USERNAME:$SSH_USERPASS" | chpasswd
  echo "password reset for [$USERNAME] [password: $SSH_USERPASS]"
}

docker_process_init_files /ssh.init.d/*
_reset_password
/usr/bin/ssh-keygen -A
exec /usr/sbin/sshd -D
