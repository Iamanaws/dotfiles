{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports = [
    ../../roles/core
    ./display.nix
    ./options.nix
  ];

  networking.hostName = "pwnbox";

  users.users = {
    iamanaws = {
      initialPassword = "password123!";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = [
        "wheel"
        "input"
      ];
    };
  };

  home-manager = {
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs outputs systemType;
      hostConfig = config;
    };
    users = {
      iamanaws = import ../../../home/users/iamanaws/nixos/pwnbox;
    };
  };

  environment.systemPackages = with pkgs; [
    ################
    ##  utilities ##
    ################
    bat
    gobuster
    hashcat
    netcat-openbsd
    ngrep
    nmap
    openvpn
    subfinder
    whatweb

    bettercap
    caido
    cyberchef
    # ghidra
    # htb-toolkit
    # metasploit
    # rizin
    # rizinPlugins.rz-ghidra
    ################
    ##    devel   ##
    ################
    go
    python3

    ################
    ##  wordlists ##
    ################
    seclists
  ];

  virtualisation.vmVariant.virtualisation = {
    resolution = {
      x = 1920;
      y = 1080;
    };
    qemu.options = [
      "-smp 6"
      "-m 8192"
      "-display gtk,zoom-to-fit=true"
      "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
      "-device virtio-serial-pci"
      "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
    ];

    spiceUSBRedirection.enable = false;

    sharedDirectories = {
      hostshare = {
        source = "$HOME/vms/pwnbox/shared";
        target = "/mnt/hostshare";
      };
    };
  };

  environment.etc."tmpfiles.d/hostshare.conf".text = ''
    d /mnt/hostshare 0755 root root -
  '';

  # Define the filesystem mount for the shared directory within the guest
  fileSystems."/mnt/hostshare" = {
    device = "hostshare";
    fsType = "9p";
    options = [
      "trans=virtio" # Use virtio transport
      "version=9p2000.L" # Use the Linux extensions for 9p
      "_netdev" # Indicate it's a network device (prevents mount issues at boot)
      "nofail" # Prevent boot failure if the share isn't available
      "rw" # Mount read-write
      "uid=1000"
      "gid=100"
    ];
  };

  services.spice-vdagentd.enable = true;

  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
