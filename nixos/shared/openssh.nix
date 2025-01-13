{config, ...}: {
  imports = [
    ./sops.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        # ben@cdodev
        ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFzgRjm1wAWFAEuSoY8pJxim8Ywj/onEA+K1e+4BvQeKCK6P9X4+Ho+I/wyEn87PYZITm1aUuFu1zOCPZpeLUlJdJq00xAZMARJyO4pf5UfcbzlVUP8og+AKAa5ELA1kJqeHQFcuesmvosnQmQWmeqThBUgFwhbyKju4J7T008e5smkQRstgEp57yayW3iYXi4nzNUEDn5M7PkdwCiFAcMAubiSrywAQo/6GmeoR8BOl1qJfH0v0+crklLIC+kRHSezi0AzF+RdTzZgseXQUgpzODv4abh/+hK46ez+Wzr4NRo564D8ipAysMJh6dF52QmcK/wKsOzyHOd0oF/0DnzncKLvFgs3QjhJUDTmAyUZmVKVfoN2RvVqvWuXSYN2s65Twj4TqCxnPKi5cxvh9HM/4h/7fYKhAhM+rTUgt7R6o3Iga1c8D2H5kCNuTjfTozNI/6SQmtrnupchKDO0+r/78oGTDM6sj0ss1O4pxIh6O6z5UbKdubf5+NMD2OQJHk= ben@cdodev''
        # vii@nikbook
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7zhSffzoHpHVr8/TDJnhzvzDAWkS8GZO9udQaJ+ftl''
      ];
    };

    nikolai = {
      hashedPasswordFile = config.sops.secrets."passwords/nikolai".path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH7zhSffzoHpHVr8/TDJnhzvzDAWkS8GZO9udQaJ+ftl vii@nikbook"
      ];
      extraGroups = ["wheel"];
    };
  };
}
