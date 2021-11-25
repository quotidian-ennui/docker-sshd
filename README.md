# docker-sshd

The suggested name was `expert-parakeet`. It's really not that interesting; but I built it because I raised this issue https://github.com/adaptris/interlok/issues/832 and it's easier to muck around with a docker image for building your test packs than anything else.

# Customisations

## username/password

You can use `direnv` or similar to specify _SSH_PASSWORD_ which will hard-code the password to whatever you want. If you don't force a password then a new one will be created for you each time.

You can also change the configured user by passing in `ssh_user` as a build argument to docker-compose and also setting SSH_USERNAME via `direnv` again.

## Startup

Put a bunch of `*.sh` files into ssh.init.d and they will be automatically executed on startup (if they have the execute bit); so if you wanted to bootstrap an initial directory structure you could do something like (you are running as root) named `ssh.init.d/00-init-dirs.sh`

```sh
#!/bin/sh
set -euo pipefail

USERNAME=${SSH_USERNAME:="user"}
USER_HOMEDIR=/home/$USERNAME
INTERLOK_DIR=$USER_HOMEDIR/MyInterlokInstance

DIRS="$INTERLOK_DIR/to-interlok \
      $INTERLOK_DIR/from-interlok"
for dir in $DIRS
do
  mkdir -p $dir
done
chown -R $USERNAME:$USERNAME $INTERLOK_DIR
```

## SSHD

Basically, the things you need to know are if you want to modify `sshd_config`

### ChallengeResponseAuthentication

Enable ChallengeResponseAuthentication, disable PasswordAuthentication. Under the covers PAM will basically use the Unix password but you essentially get the equivalent of `PreferredAuthentications=publickey,keyboard-interactive`

```
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication yes
ChallengeResponseAuthentication yes
KerberosAuthentication no
GSSAPIAuthentication no
```


### PasswordAuthentication

Disable ChallengeResponseAuthentication, enable PasswordAuthentication. This would be the equivalent of `PreferredAuthentications=publickey,password`.

```
PubkeyAuthentication yes
PasswordAuthentication yes
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
```

### PubkeyAuthentication

PubkeyAuthentication is enabled by default, and if you put an `authorized_keys` file into the .ssh directory, it will get automatically added into the users _.ssh_ at build time.