# Installing an existing system

## On the target machine

- Boot mashing F2
- Select "Administer Secure Boot"
- Disable "Enforce Secure Boot"
- Press F10 to save and exit
- Boot mashing F2
- Boot using Ventoy into nixos gnome iso

```bash
# switch to the root user
sudo su - root

# set a temporary password '12345'
passwd

# get the ip address of the system
ip addr
```

### On the source machine

- set secure-boot to false, git add but don't commit

```bash
# enter the bootstrap nix shell
nix develop

# set environment variables for the system to be installed
# (change values as needed)
export \
  user="jacobranson" \
  hostname="framework-16-7040-amd" \
  arch="x86_64-linux" \
  ip="192.168.1.102"

# ssh in using the temporary password '12345';
# copy the ssh id of the source machine to the target machine
ssh-keygen -R "$ip"; \
  ssh-copy-id -i ~/.ssh/id_ed25519.pub "root@$ip" && \
  ssh "root@$ip"

# delete the temporary root password, since we have the
# ssh id of the source machine now
passwd -d root

# disconnect from the ssh session
exit

# trigger the install process
bootstrap
```

- revert changes to secure boot
