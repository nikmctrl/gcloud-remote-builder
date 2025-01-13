{...}: {
  sops.defaultSopsFile = ../../secrets/general.yaml;

  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key" "/Users/vii/.ssh/id_ed25519"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  sops.secrets."passwords/nikolai" = {
    neededForUsers = true;
  };

  sops.secrets."passwords/root" = {
    neededForUsers = true;
  };

  sops.secrets."github-runners/nix-gh-ci" = {};
}
