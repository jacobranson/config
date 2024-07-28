# POSTINSTALL

## Networking

- Connect to WiFi via desktop environment settings.
- Connect Bluetooth devices via desktop environment settings.

## Fingerprint Scanner

```bash
fprintd-enroll
```

## GitHub CLI & User SSH Keys

```bash
# login to the GitHub CLI
gh auth login

# clone this repo
cd ~/Projects
gh repo clone config

# decrypt the user ssh key
cd ~/Projects/config
nix develop ".#bootstrap"
postinstall
```

## Secure Boot

- `bootctl status` (should be disabled)
- `nh os switch`
- `sudo sbctl create-keys`
- `nh os switch`
- `sudo sbctl verify` (ignore bzImage.efi)
- reboot mashing F2
- Select "Administer Secure Boot"
- Select "Erase all Secure Boot Settings"
- Enable "Enforce Secure Boot".
- Press F10 to save and exit
- reboot mashing F2
- Config
- Security
- TPM Operation - Enable
- Clear TPM - ON
- Press F10 to save and exit
- `sudo sbctl enroll-keys --microsoft`
- reboot
- `bootctl status` (should be enabled)
- `ls -l /sys/firmware/efi/efivars/dbx*` (should have data)
- `sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/nvme0n1p3` (replace p3 with the encrypted partition number if needed)
- enter passphrase for decrypting disk
- reboot (no more passphrase needed!)
