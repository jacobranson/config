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
ujust _setup-ssh
```

## GitHub CLI & Cloning Config

```bash
# login to the GitHub CLI
gh auth login

# clone this repo
gh repo clone config ~/Projects/config
```

## Secure Boot

- `bootctl status` (secure boot should be disabled)
- `sudo sbctl create-keys`
- `nh os switch` (will enable secure boot)
- `sudo sbctl verify` (all but one should be good)
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
- `bootctl status` (secure boot should be enabled)
- `ls -l /sys/firmware/efi/efivars/dbx*` (should output something)
- `ujust _setup-tpm` (removes need to enter luks password; change the device arg if needed)
- enter passphrase for decrypting disk
- reboot (no more passphrase needed!)
