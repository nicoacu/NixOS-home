# buscar como guardar en nixos "editor.renderWhitespace": "boundary"
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./homemanager.nix
  ];

  # @nicoacu 16-10-24: adding nvidia settings temporarily here. should be on a nvidia.nix file
  # Enable OpenGL
  #hardware.opengl = {
  #  enable = true;
  #};

  # Load nvidia driver for Xorg and Wayland
  #services.xserver.videoDrivers = ["nvidia"];

  #hardware.nvidia = {
  # Modesetting is required.
  #  modesetting.enable = true;

  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  # Enable this if you have graphical corruption issues or application crashes after waking
  # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  # of just the bare essentials.
  #  powerManagement.enable = true;

  # Fine-grained power management. Turns off GPU when not in use.
  # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #  powerManagement.finegrained = false;

  # Use the NVidia open source kernel module (not to be confused with the
  # independent third-party "nouveau" open source driver).
  # Support is limited to the Turing and later architectures. Full list of
  # supported GPUs is at:
  # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
  # Only available from driver 515.43.04+
  # Currently alpha-quality/buggy, so false is currently the recommended setting.
  # open = false;

  # Enable the Nvidia settings menu,
  # accessible via `nvidia-settings`.
  #  nvidiaSettings = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #  };

  # Enable flakes feature.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5; # only keep 5 generations in the bootloader.

  networking.hostName = "roach"; # Define your hostname.

  # Add another dns in /etc/hosts
  networking.extraHosts = ''
    127.0.0.1 expedientes.local
    192.168.0.63 berrypi.traefik
  '';

  #@nia: bandaid fix to taking long time to load pages in firefox according to https://discourse.nixos.org/t/long-loading-in-firefox/25055/3
  networking.enableIPv6 = false;
  boot.kernelParams = ["ipv6.disable=1"];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # REVIEW: Increased timeout of NetworkManager-wait-online.service so it can wait for the virtualbox network to be up
  systemd.services.NetworkManager-wait-online.serviceConfig.TimeoutStartSec = "2min";

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "latam";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nacuna = {
    isNormalUser = true;
    description = "Nico";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "docker"];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    vim
    neofetch
    wget
    curl
    spotify
    vagrant # investigar alternativa con deploy-rs o nixops/morph
    openlens
    k9s
    kubectl
    kustomize
    ansible
    unzip
    zoom-us
    discord
    masterpdfeditor
    google-chrome #unfree
    vesktop
    obs-studio
    vlc

    ## Guake Terminal
    # Note: might have issues using F12 to open and close the window. workaround: https://github.com/Guake/guake/issues/1642#issuecomment-580668579 until I find/create a declarative way to fix it
    guake

    ## Utilities
    jq # lightweight and flexible command-line json processor
    envsubst # env var substitution for go
    freerdp # RDP client
    dig # DNS lookup utility
    openssl

    ## Development
    git
    gitflow
    nodejs_22
    python3
    docker-compose
    go
    hugo
    gccgo13 #system c compiler (wrapper script) needed in hugo extended
    minikube

    ## Cloud
    google-cloud-sdk
    terraform
    obsidian
    kubernetes-helm
    argocd

    ## Packet Tracer Cisco https://nixos.wiki/wiki/Packettracer (Disclaimer: is a garron to install)
    # 1) Download latest version: https://www.netacad.com/portal/resources/file/f40aaa18-2b25-4337-81a3-8f989232abf6
    #
    # 2) Add to the nix store with
    # nix-store --add-fixed sha256 CiscoPacketTracer822_amd64_signed.deb
    # and/or
    # nix-prefetch-url --type sha256 file://$HOME/Downloads/CiscoPacketTracer822_amd64_signed.deb
    # 3) add the package below
    ciscoPacketTracer8
  ];

  ## Enable virtualbox (this includes the kernel modules and all the shenanigans)
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.host.headless = false; #to control virtualbox with cli and not GUI

  ## Enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  ## Automatic gargabe control
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {

  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

  # About Updates: https://nixos.org/manual/nixos/stable/index.html#sec-upgrading
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}
