# TODO

- how to get user ssh key onto system before first boot?
- zfs auto-decrypt dataset with tpm
- what is .nix-profile supposed to point to?
- how to hide mounts for home folders?
- Use [systemd paths](https://mynixos.com/nixpkgs/options/systemd.paths.%3Cname%3E) to watch for changes to the following files and auto copy them to/from `/persist`
  - `.local/share/recently-used.xbel`
  - `.config/monitors.xml`
- Workaround for nautilus trash support [nautilus-trash-cli](https://github.com/Kiszczomb/nautilus-trash-cli)

# Limitations

- [Nautilus cannot trash files on subvolumes](https://gitlab.gnome.org/GNOME/glib/-/issues/1885)
- [Monitor configuration is not persisted automatically](https://github.com/nix-community/impermanence/issues/147)
  - Workaround: `ujust save-monitor-config` and `ujust load-monitor-config`
- [Recently used files in Nautilus is not persisted automatically](https://github.com/nix-community/impermanence/issues/147)
