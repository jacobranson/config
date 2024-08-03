# Installing an existing system

## Pre-install

### On the target machine

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

```bash
# enter the bootstrap nix shell
nix develop

# set environment variables for the system to be installed
# (change values as needed)
export \
  user="jacobranson" \
  hostname="framework-16-7040-amd" \
  arch="x86_64-linux" \
  ip="192.168.1.64"

# set secureBoot to false, git add but don't commit

# ssh in using the temporary password '12345';
# copy the ssh id of the source machine to the target machine
ssh-keygen -R "$ip"; \
  ssh-copy-id -i ~/.ssh/id_ed25519.pub "root@$ip" && \
  ssh "root@$ip"

# ensure you are connected to the remote system

# delete the temporary root password, since we have the
# ssh id of the source machine now
passwd -d root

# disconnect from the ssh session
exit

# trigger the install process
bootstrap

# discard staged git changes
```

## Post-install

### Networking

- Connect to a WiFi network, if necessary.
- Connect your various Bluetooth devices, if necessary.

### Fingerprint Scanner

```bash
fprintd-enroll
```

### User SSH Keys

```bash
ujust _setup-ssh
```

### Wait for Flatpaks to install...

### GitHub CLI & Cloning Config

```bash
# login to the GitHub CLI
gh auth login

# clone this repo
gh repo clone config ~/Projects/config
```

### Secure Boot

- `bootctl status` (secure boot should be disabled)
- `sudo sbctl create-keys`
- `nh os switch` (will enable secure boot)
- `sudo sbctl verify` (all but one should be good)
- reboot mashing F2
- Select "Administer Secure Boot"
- Enable "Erase all Secure Boot Settings"
- Enable "Enforce Secure Boot".
- Press F10 to save and exit
- reboot mashing F2
- Setup Utility
- Security
- TPM Operation - Enable
- Clear TPM - ON
- Press F10 to save and exit
- `sudo sbctl enroll-keys --microsoft`
- reboot
- `bootctl status` (secure boot should be enabled)
- `ls -l /sys/firmware/efi/efivars/dbx*` (should output something)

### TPM LUKS Decryption

This will remove the need for you to type in your LUKS password
on boot to decrypt your drive. If you set the same LUKS password
as the primary user password, the GNOME Keychain will auto-unlock
upon login, as well!

- `ujust _setup-tpm` (removes need to enter luks password; change the device arg if needed)
- enter passphrase for decrypting disk
- reboot (no more passphrase needed!)

### Cleanup

```bash
# remove the non-secureBoot first generation
nh clean all
```

### Steam

- Sign in to Steam
- Opt in to the Steam Beta
- Force the use of compat tools
- Set "Steam Tinker Launch" as the default compat tool
