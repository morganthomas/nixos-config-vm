# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  fileSystems."/".label = "vmdisk";

  networking.hostName = "vmhost";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./bootloader.nix
    ];

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget chromium git tmate python wdiff psmisc zip nix-prefetch-git vim
    gnumake gcc binutils-unwrapped ncurses5 zlib.dev
    gnupg dos2unix nix-serve usbutils htop fd dmenu networkmanager
  ];

  shpadoinkle = builtins.fetchGit {
    url    = https://gitlab.com/morganthomas/Shpadoinkle.git;
    rev    = "c65dc2289849b005a680f96b236bb3a46b395be3";
    ref    = "update-continuations";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = false;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,us";
  services.xserver.xkbVariant = ",dvorak";
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.xserver.xkbOptions = "ctrl:swapcaps,grp:ctrl_shift_toggle";
  services.xserver.videoDrivers = [ "intel" ];
  
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  services.locate.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
  system.autoUpgrade.enable = false;
  networking.timeServers = options.networking.timeServers.default;
  
  nix.binaryCaches = [ "https://nixcache.reflex-frp.org" "https://cache.nixos.org" "https://shpadoinkle.cachix.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "shpadoinkle.cachix.org-1:aRltE7Yto3ArhZyVjsyqWh1hmcCf27pYSmO1dPaadZ8=" ];

  users.users.morgan = {
    isNormalUser = true;
    home = "/home/morgan";
    description = "Morgan Thomas";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$UA0JUjqoFY$nPFQ9Cohj5K1az3XUFarNlLjknmNHaxuAV0MN.VI5rHe9.YkSu.8qmobN6MEA4/mgfoowSA9xwleewuM8ZtKB/"; # the password is "password"
  };
}
