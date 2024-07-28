# SSH Key locations
#   On macOS, system keys must be generated manually with `ssh-keygen -A`.
#   On Linux & macOS, user keys must be generated manually with `ssh-keygen -t ed25519`.
#
#   System keys can be found at `/etc/ssh/`.
#   User keys can be found at `~/.ssh`.

{
  systems = {
    "framework-16-7040-amd" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe1b4sB4WFAO5klXKq1SLspoBSNrC/PYAzax2CoywCz root@framework-16-7040-amd";
    "macbook-air-m1" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYmCCz03CYonSgPqx9CoES5NsPDCu0JXP81OVC7HANt root@macbook-air-m1";
  };
  users = {
    "jacobranson@framework-16-7040-amd" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBPkA4hDjA+NbRsdzbqAZgG+DaX99fF/5Wth+eVGbh2 jacobranson@framework-16-7040-amd";
    "jacobranson@macbook-air-m1" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDn0Yy40JUryQ7nneBrv6lh8XKyTVwKZm7lgGoAyY/Et jacobranson@macbook-air-m1";
  };
}
