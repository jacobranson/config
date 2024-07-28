# Onboarding a new system

## On the target machine

```bash
# switch to the root user
sudo su - root

# set a temporary password '12345'
passwd

# get the ip address of the system
ip addr
```

### On the source machine


```bash
# enter the bootstrap nix shell
nix develop

# set environment variables for the system to be installed
# (change values as needed)
export \
  user="jacobranson" \
  hostname="framework-16-7040-amd" \
  arch="x86_64-linux" \
  ip="192.168.1.101"

# ssh in using the temporary password '12345';
# copy the ssh id of the source machine to the target machine
ssh-keygen -R "$ip"; \
  ssh-copy-id -i ~/.ssh/id_ed25519.pub "root@$ip" && \
  ssh "root@$ip"

# delete the temporary root password, since we have the
# ssh id of the source machine now
passwd -d root

# create default nixos config
nixos-generate-config --no-filesystems --root /mnt

# copy disk layout
lsblk > /mnt/etc/disks.txt

# copy ssh host key pair
mkdir -p /mnt/etc/ssh && cp -r /etc/ssh/ssh_host_ed25519* /mnt/etc/ssh

# copy machine id
cp /etc/machine-id /mnt/etc

# disconnect from the ssh session
exit

# create a directory to store files from target machine temporarily
mkdir -p mnt

# copy /mnt to the source machine
rsync -e ssh -azvhP "root@$ip:/mnt/" ./mnt

# configure the system via this flake...

# trigger the install process
bootstrap

# remove temporary files
rm -rf mnt

```
