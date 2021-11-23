# docker-sshd

The suggested name was `expert-parakeet`. It's really not that interesting; but I built it because I raised this issue https://github.com/adaptris/interlok/issues/832 and it's easier to muck around with a docker image for building your test packs than anything else.

Basically, the things you need to know are

## ChallengeResponseAuthentication

Enable ChallengeResponseAuthentication, disable PasswordAuthentication. Under the covers PAM will basically use the Unix password but you essentially get the equivalent of `PreferredAuthentications=publickey,keyboard-interactive`

```
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication yes
ChallengeResponseAuthentication yes
KerberosAuthentication no
GSSAPIAuthentication no
```


## PasswordAuthentication

Disable ChallengeResponseAuthentication, enable PasswordAuthentication. This would be the equivalent of `PreferredAuthentications=publickey,password`.

```
PubkeyAuthentication yes
PasswordAuthentication yes
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
```

