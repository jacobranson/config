# FAQs

## Q: sudo "no new privileges" flag is set

A: You cannot use sudo in FHS Environments in NixOS, meaning
   that trying to elevate to a root shell in VSCode, or some
   other application built in an FHS-compatibile environment
   will fail with that error. Just use the native terminal for
   commands requiring superuser privileges.
