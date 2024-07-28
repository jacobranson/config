# POSTINSTALL

## Networking

- Connect to a WiFi network, if necessary.
- Connect your various Bluetooth devices, if necessary.

## Fingerprint Scanner

```bash
fprintd-enroll
```

## User SSH Keys

```bash
key="$HOME/.ssh/id_ed25519"
sudo cat /run/agenix/users/$(whoami)/id_ed25519 > "$key"
chmod 600 "$key"
nix-shell -p openssl --command "openssl pkey -in $key -pubout > $key.pub"
chmod 644 "$key.pub"
```

## GitHub CLI & Cloning Config

```bash
# login to the GitHub CLI
gh auth login

# clone this repo
gh repo clone config ~/Projects/config
```

## Secure Boot

- `bootctl status` (should be disabled)
- `nh os switch` (will download stuff, also enables secure-boot)
- `sudo sbctl create-keys`
- `nh os switch` (will use the keys we just generated)
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
- `sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/nvme0n1p3` (replace p3 at the end with the encrypted partition number if needed)
- enter passphrase for decrypting disk
- reboot (no more passphrase needed!)
