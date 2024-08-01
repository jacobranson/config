# any time this file is modified, you must
# run agenix --rekey and commit everything

let
  public-keys = (import ./ssh-public-keys.nix);
  secrets = {
    framework-16-7040-amd = {
      path = "systems/x86_64-linux/framework-16-7040-amd/secrets";
      files = [
        "luks/nvme0n1/password"
        "users/jacobranson/password"
        "users/jacobranson/id_ed25519"
        "users/root/password"
        "ssh_host_ed25519_key"
      ];
      authorized-keys = with public-keys; [
        systems."framework-16-7040-amd"
        users."jacobranson@framework-16-7040-amd"
        users."jacobranson@macbook-air-m1"
      ];
    };
    macbook-air-m1 = {
      path = "systems/aarch64-darwin/macbook-air-m1/secrets";
      files = [];
      authorized-keys = with public-keys; [
        systems."macbook-air-m1"
        users."jacobranson@macbook-air-m1"
        users."jacobranson@framework-16-7040-amd"
      ];
    };
  };
in
  with builtins; (
    foldl' (acc: elem: elem // acc) {} (map (key:
      let
        path = secrets."${key}".path;
        files = secrets."${key}".files;
        authorized-keys = secrets."${key}".authorized-keys;
      in (
        foldl' (acc: elem: elem // acc) {} (
          map (file:
            { "${path}/${file}.age".publicKeys = authorized-keys; }
          ) files
        )
      )
    ) (attrNames secrets))
  )
