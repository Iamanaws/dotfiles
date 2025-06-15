{
  inputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports = [
    "${inputs.nix-mineral}/nix-mineral.nix"
  ];

  #usbguard
  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_hardened;

    # Enable unprivileged user namespaces (kernel-level risk)
    # for chromium based apps, flatpacks, and steam sandboxing
    kernel.sysctl = lib.optionalAttrs (systemType != null) {
      "kernel.unprivileged_userns_clone" = 1;
    };
  };

  nix-mineral = {
    enable = true;
    overrides = {
      compatibility = {
        # allow-unsigned-modules = true;
        # allow-busmaster-bit = true;
        # allow-ip-forward = true;
        # no-lockdown = true;
      };

      desktop = lib.optionalAttrs (systemType != null) {
        # allow-multilib = true;
        # doas-sudo-wrapper = true;
        # hideproc-ptraceable = true;
        hideproc-off = true;
        home-exec = true;
        skip-restrict-home-permission = true;
        nix-allow-all = true;
        tmp-exec = true;
        # usbguard-gnome-integration = true;
        var-lib-exec = true;
      };

      performance = {
        # allow-smt = true;
        # iommu-passthrough = true;
        # no-mitigations = true;
        # no-pti = true;
      };

      security = {
        # disable-bluetooth-kmodules = true;
        # disable-intelme-kmodules = true;
        # disable-amd-iommu-forced-isolation = true;
        # lock-root = true;
        minimize-swapping = true;
        # sysrq-sak = true;
      };

      software-choice = {
        # doas-no-sudo = true;
        # no-firewall = true;
        secure-chrony = true;
      };
    };
  };

  # Client side SSH configuration
  programs.ssh = {
    ciphers = [
      "aes256-gcm@openssh.com"
      "aes256-ctr,aes192-ctr"
      "aes128-ctr"
      "aes128-gcm@openssh.com"
      "chacha20-poly1305@openssh.com"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    knownHosts = {
      github-rsa = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
      };
      github-ed25519 = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab-rsa = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
      };
      gitlab-ed25519 = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };
}
