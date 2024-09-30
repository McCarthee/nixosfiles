{ pkgs, inputs, ... }:

{
   imports = 
      [
         ./hardware-configuration.nix
         inputs.home-manager.nixosModules.default
      ];

   # Enable flakes.
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

   hardware = {
      bluetooth = {
         enable = true;
         powerOnBoot = true;
      };

      graphics = {
         enable32Bit = true;
         extraPackages = with pkgs; [
            amdvlk
         ];
         extraPackages32 = with pkgs; [
            driversi686Linux.amdvlk
         ];
      };

      pulseaudio.enable = false;
   };

   powerManagement.cpuFreqGovernor = "performance";

   # Bootloader.
   boot = {
      loader = {
         timeout = 0;
         systemd-boot.enable = true;
         efi.canTouchEfiVariables = true;
      };

      initrd = {
         verbose = false;
         kernelModules = [ "amdgpu" ];
      };

      plymouth = {
         enable = true;
         theme = "bgrt";
         themePackages = with pkgs; [ nixos-bgrt-plymouth ];
      };

      # Enable "Silent Boot"
      consoleLogLevel = 0;
      kernelParams = [
         "quiet"
         "splash"
         "boot.shell_on_fail"
         "loglevel=3"
         "rd.systemd.show_status=false"
         "rd.udev.log_level=3"
         "udev.log_priority=3"
      ];
   };

   networking = {
      hostName = "desktop"; # Define your hostname.
      networkmanager.enable = true;
   };

   # Set your time zone.
   time.timeZone = "Europe/London";

   # Select internationalisation properties.
   i18n = {
      defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
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
   };

   documentation.nixos.enable = false;

   services = {
      printing.enable = true;
      avahi = {
         enable = true;
         nssmdns4 = true;
         openFirewall = true;
      };

      xserver = {
         enable = true;

         displayManager.gdm.enable = true;
         desktopManager.gnome.enable = true;

         xkb = {
            layout = "gb";
            variant = "";
         };

         excludePackages = [ pkgs.xterm ];
      };

      pipewire = {
         enable = true;
         alsa.enable = true;
         alsa.support32Bit = true;
         pulse.enable = true;
         jack.enable = true;
         wireplumber = {
            extraConfig = {
               "10-disable_gpu-audio" = {
                  "monitor.alsa.rules" = [{
                     matches = [{
                        "device.name" = "alsa_card.pci-0000_03_00.1";
                     }];
                     actions = {
                        update-props = {
                           "device.disabled" = true;
                        };
                     };
                  }];
               };
               "10-disable_builtin-audio" = {
                  "monitor.alsa.rules" = [{
                     matches = [{
                        "device.name" = "alsa_card.pci-0000_00_1f.3";
                     }];
                     actions = {
                        update-props = {
                           "device.disabled" = true;
                        };
                     };
                  }];
               };
            };
            configPackages = [
               (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
                  wireplumber.settings = { bluetooth.autoswitch-to-headset-profile = false }
               '')
            ];
         };
      };
   };

   # Configure console keymap
   console.keyMap = "uk";

   security.rtkit.enable = true;

   # Set up displays in GDM
   systemd.tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
         <!-- this should all be copied from your ~/.config/monitors.xml -->
         <monitors version="2">
            <configuration>
               <logicalmonitor>
                  <x>0</x>
                  <y>1080</y>
                  <scale>1</scale>
                  <primary>yes</primary>
                  <monitor>
                     <monitorspec>
                        <connector>HDMI-1</connector>
                        <vendor>GSM</vendor>
                        <product>24GL600F</product>
                        <serial>0x0005f4fb</serial>
                     </monitorspec>
                     <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>143.998</rate>
                     </mode>
                  </monitor>
               </logicalmonitor>
               <logicalmonitor>
                  <x>0</x>
                  <y>0</y>
                  <scale>1</scale>
                  <monitor>
                     <monitorspec>
                        <connector>DP-1</connector>
                        <vendor>GSM</vendor>
                        <product>24GL600F</product>
                        <serial>0x000476b4</serial>
                     </monitorspec>
                     <mode>
                        <width>1920</width>
                        <height>1080</height>
                        <rate>143.998</rate>
                     </mode>
                  </monitor>
               </logicalmonitor>
            </configuration>
         </monitors>
      ''}"
   ];

   # Define a user account. Don't forget to set a password with ‘passwd’.
   users = {
      defaultUserShell = pkgs.fish;
      users.george = {
         isNormalUser = true;
         description = "George";
         extraGroups = [ "networkmanager" "wheel" ];
      };
   }; 

   home-manager = {
      # also pass inputs to home-manager modules
      extraSpecialArgs = { inherit inputs; };
      users = {
         "george" = import ./home.nix;
      };
   };

   # Allow unfree packages.
   nixpkgs.config.allowUnfree = true;

   environment = {
      systemPackages = with pkgs; [
         (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
         # GNOME extensions.
         gnomeExtensions.tiling-assistant
         gnomeExtensions.no-overview
         gnomeExtensions.alphabetical-app-grid
         gnomeExtensions.appindicator

         # Fonts.
         noto-fonts
         noto-fonts-extra
         noto-fonts-cjk
         noto-fonts-emoji
         liberation_ttf
         inter

         # GUI Applications
         brave
         plexamp
         gnome-tweaks
         celluloid
         blackbox-terminal
         
         # Languages.
         nodejs_22
         
         # TUI Applications
         fastfetch
         eza
         dconf2nix

         # Theming.
         adw-gtk3

         # Gaming.
         wineWowPackages.staging
         bottles
         mangohud
         protonplus
         wowup-cf

         # Extraction
         dtrx
         p7zip
         unrar
         unzip
      ];

      gnome.excludePackages = (with pkgs; [
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
         gnome-console
      ]);
   };

   fonts = {
      fontconfig.subpixel.rgba = "rgb";
      packages = with pkgs; [];
   };

   programs = {
      fish.enable = true;
      steam = {
         enable = true;
         remotePlay.openFirewall = true;
         dedicatedServer.openFirewall = true;
         localNetworkGameTransfers.openFirewall = true;
      };

      gamemode.enable = true;
      htop.enable = true;
   };

   # virtualisation.waydroid.enable = true;

   system.stateVersion = "24.05";
}
