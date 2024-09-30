{ config, pkgs, inputs, ... }:

{
   imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
   ];

   boot = {
      plymouth = {
         enable = true;
         theme = "bgrt";
         themePackages = with pkgs; [ nixos-bgrt-plymouth ];
      };

      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
         "quiet"
         "splash"
         "boot.shell_on_fail"
         "loglevel=3"
         "rd.systemd.show_status=false"
         "rd.udev.log_level=3"
         "udev.log_priority=3"
      ];
      # Hide the OS choice for bootloaders.
      loader.timeout = 0;
  };

   # Bootloader.
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;

   # Define your hostname.
   networking.hostName = "nixos";

   # Enable flake support.
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

   # Set Bash aliases.
   programs.bash.shellAliases = {
      nixedit = "sudo code /etc/nixos/ --user-data-dir='.' --no-sandbox";
   };

   # Enable networking.
   networking.networkmanager.enable = true;
   networking.wireless.enable = false;

   # Set your time zone.
   time.timeZone = "Europe/London";

   # Select internationalisation properties.
   i18n.defaultLocale = "en_GB.UTF-8";
   i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
   };

   # Enable the X11 windowing system.
   services.xserver.enable = true;

   # Enable the GNOME desktop environment.
   services.xserver.displayManager.gdm.enable = true;
   services.xserver.desktopManager.gnome.enable = true;

   services.xserver.excludePackages = [ pkgs.xterm ];

   # Configure keymap in X11.
   services.xserver.xkb = {
      layout = "gb";
      variant = "";
   };

   # Configure console keymap.
   console.keyMap = "uk";

   # Set up printing.
   services.printing.enable = true;
   services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
   };

   # Enable Wayland for some apps
   environment.sessionVariables.NIXOS_OZONE_WL = "1";
   
   # Font optimizations.
   fonts.fontconfig.subpixel.rgba = "rgb";

   # Enable sound with pipewire.
   hardware.pulseaudio.enable = false;
   security.rtkit.enable = true;
   services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
   };

   # Enable touchpad support.
   services.libinput.enable = true;

   # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users = {
      george = {
         isNormalUser = true;
         description = "George";
         extraGroups = [ "networkmanager" "wheel" ];
         packages = with pkgs; [];
      };
   };

   home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs; };
      users = {
         "george" = import ./home.nix;
      };
   };

   # Allow unfree packages
   nixpkgs.config.allowUnfree = true;

   # List packages installed in system profile. To search, run:
   environment.systemPackages = with pkgs; [
      nodejs_22
      brave
      gnome-tweaks
      fastfetch
      eza
      adw-gtk3
   ];

   fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
   ];

   environment.gnome.excludePackages = (with pkgs; [
      gnome-contacts
      snapshot
      gnome-tour
      gnome-maps
      totem
      yelp
      gnome-calendar
      gnome-system-monitor
      gnome-music
      gnome-clocks
      gnome-weather
      geary
      epiphany
      gnome-connections
      gnome-calculator
      gnome-characters
      gnome-logs
      baobab
      gnome-font-viewer
   ]);

   system.stateVersion = "24.05";
}
