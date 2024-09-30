{ pkgs, lib, inputs, config, ... }: {

   imports = [
      inputs.nixvim.homeManagerModules.nixvim
      inputs.catppuccin.homeManagerModules.catppuccin
   ];

   gtk.gtk4.extraConfig.gtk-hint-font-metrics = 1;

   home = {
      stateVersion = "24.05";
      username = "george";
      homeDirectory = "/home/george";
      
      sessionVariables = {
         NIXOS_OZONE_WL = "1";
      };

      packages = with pkgs; [];

      file = {
         "monitors.xml" = {
            source = ./monitors.xml;
            target = ".config/monitors.xml";
         };

         "blackbox-dark_catppuccin-mocha-theme.json" = {
            source = ./blackbox-dark_catppuccin-mocha-theme.json;
            target = ".local/share/blackbox/schemes/catppuccin-mocha.json";
         };

         "blackbox-light_catppuccin-latte-theme.json" = {
            source = ./blackbox-light_catppuccin-latte-theme.json;
            target = ".local/share/blackbox/schemes/catppuccin-latte.json";
         };
      };
   };

   home.file = {};

   dconf = {
      enable = true;
      settings = {
         "org/gnome/desktop/wm/preferences" = {
            focus-mode = "sloppy";
            button-layout = "appmenu:minimize,maximize,close";
         };

         "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Shift><Super>c" ];
         };

         "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
            home = [ "<Super>slash" ];
            www = [ "<Super>w" ];
         };

         "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            name = "Blackbox Terminal";
            command = "blackbox";
         };

         "org/gnome/TextEditor" = {
            highlight-current-line = true;
            show-line-numbers = true;
            indent-style = "space";
            tab-width = 4;
            auto-indent = true;
            show-map = true;
            restore-session = false;
         };

         "org/gnome/shell" = {
            last-selected-power-profile = "performance";
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
               tiling-assistant.extensionUuid
               no-overview.extensionUuid
               alphabetical-app-grid.extensionUuid
               appindicator.extensionUuid
            ];

            favorite-apps = [
               "org.gnome.Nautilus.desktop"
               "plexamp.desktop"
               "brave-browser.desktop"
               "steam.desktop"
               "com.raggesilver.BlackBox.desktop"
               "org.gnome.Settings.desktop"
            ];
         };

         "org/gnome/shell/extensions/tiling-assistant" = {
            active-window-hint = 0;
         };

         "org/gnome/shell/extensions/appindicator" = {
            icon-opacity = 255;
            icon-size = 20;
         };

         "org/gnome/mutter" = {
            dynamic-workspaces = true;
            attach-modal-dialogs = true;
            workspaces-only-on-primary = true;
         };

         "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark"; # Dark theme
            enable-hot-corners = false;
            gtk-theme = "adw-gtk3-dark";
            font-antialiasing = "rgba";
            font-name = "Inter Variable 11";
            monospace-font-name = "JetBrainsMono Nerd Font 10";
            show-battery-percentage = true;
            clock-show-weekday = true;
            clock-format = "12h";
            gtk-enable-primary-paste = false;
         };

         "org/gnome/desktop/sound" = {
            theme-name = "freedesktop";
         };

         "org/gnome/desktop/datetime" = {
            automatic-timezone = true;
         };

         "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
         };

         "org/gnome/desktop/screensaver" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
         };
      
         "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = 0.0;
         };

         "org/gnome/desktop/session" = {
            idle-delay = lib.hm.gvariant.mkUint32(900);
         };

         "org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
         };

         "org/gtk/settings/file-chooser" = {
            clock-format = "12h";
         };

         "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
         };

         "org/gnome/nautilus/list-view" = {
            default-zoom-level = "small";
         };

         "com/raggesilver/BlackBox" = {
            theme-dark = "Catppuccin Mocha";
            theme-light = "Catppuccin Latte";
            font = "JetBrainsMono Nerd Font 10";
            remember-window-size = true;
            floating-controls = true;
            theme-bold-is-bright = true;
            easy-copy-paste = true;
            terminal-padding = with lib.hm.gvariant; mkTuple [
               (mkUint32 10)
               (mkUint32 10)
               (mkUint32 10)
               (mkUint32 10) 
            ];
            working-directory-mode = lib.hm.gvariant.mkUint32 1;
         };
      };
   };

   programs = {
      # Let Home Manager install and manage itself.
      home-manager = {
         enable = true;
      };

      git = {
         enable = true;
         userName = "George McCarthy";
         userEmail = "mccarthee@outlook.com";
      };

      vscode = {
         enable = true;
         package = pkgs.vscodium;
         mutableExtensionsDir = false;
         enableUpdateCheck = false;
         enableExtensionUpdateCheck = false;
         userSettings = {
            window = {
               titleBarStyle = "custom";
            };

            editor = {
               fontSize = 14;
               fontFamily = "'JetBrainsMono Nerd Font', monospace";
               tabSize = 3;
               detectIndentation = false;
               cursorBlinking = "expand";
               cursorSmoothCaretAnimation = "on";
               formatOnSave = true;
               semanticHighlighting.enabled = true;
               guides.indentation = false;
            };

            git.autofetch = true;

            "workbench.iconTheme" = "catppuccin-mocha";
            workbench = {
               colorTheme = "Catppuccin Mocha";
            };

            terminal = {
               integrated.minimumContrastRatio = 1;
            };
         };

         extensions = with pkgs.vscode-extensions; [
            astro-build.astro-vscode # Astro
            bbenoist.nix # Nix
            ritwickdey.liveserver # Live Server
            ms-azuretools.vscode-docker # Docker
            catppuccin.catppuccin-vsc # Catppuccin theme
            catppuccin.catppuccin-vsc-icons # Catppuccin icon theme
            bradlc.vscode-tailwindcss # Tailwind
         ];
      };

      fastfetch = {
         enable = true;
      };

      bash = {
         enable = true;
         enableCompletion = true;
         shellAliases = {
            ls = "eza";
            lh = "eza -lh";
            lah = "eza -lah";
            hm-logs = "journalctl -r --unit home-manager-george.service";
         };
      };

      nixvim = {
         enable = true;
         viAlias = true;
         vimAlias = true;
         # colorschemes.catppuccin.enable = true;
         plugins = {
            web-devicons.enable = true;
            telescope.enable = true;
            nvim-tree.enable = true;
            treesitter.enable = true;
            lsp = {
               enable = true;
               servers = {
                  astro.enable = true;
               };
            };
         };
      };

      htop = {
         enable = true;
         settings = {
            show_cpu_frequency = 1;
            show_cpu_temperature = 1;
            fields = with config.lib.htop.fields; [
               PID
               USER
               PRIORITY
               NICE
               M_SIZE
               M_RESIDENT
               M_SHARE
               STATE
               PERCENT_NORM_CPU
               PERCENT_MEM
               TIME
               COMM
            ];
         };
      };

      btop = {
         enable = true;
      };

      starship = {
         enable = true;
      };
   };

   xdg = {
      enable = true;
      desktopEntries = {
         htop = {
            name = "Htop";
            type = "Application";
            noDisplay = true;
         };

         btop = {
            name = "btop++";
            type = "Application";
            noDisplay = true;
         };

         nvim = {
            name = "Neovim";
            type = "Application";
            noDisplay = true;
         };

         cups = {
            name = "Manage Printing";
            type = "Application";
            noDisplay = true;
         };
      };
   };

   xdg.mimeApps = {
      enable = true;
      defaultApplications = {
         "image/avif" = [ "org.gnome.Loupe.desktop" ];
         "image/bmp" = [ "org.gnome.Loupe.desktop" ];
         "image/cgm" = [ "org.gnome.Loupe.desktop" ];
         "image/g3fax" = [ "org.gnome.Loupe.desktop" ];
         "image/gif" = [ "org.gnome.Loupe.desktop" ];
         "image/heic" = [ "org.gnome.Loupe.desktop" ];
         "image/ief" = [ "org.gnome.Loupe.desktop" ];
         "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
         "image/pjpeg" = [ "org.gnome.Loupe.desktop" ];
         "image/png" = [ "org.gnome.Loupe.desktop" ];
         "image/prs.btif" = [ "org.gnome.Loupe.desktop" ];
         "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
         "image/tiff" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.adobe.photoshop" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.djvu" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.dwg" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.dxf" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.fastbidsheet" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.fpx" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.fst" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.fujixerox.edmics-mmr" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.fujixerox.edmics-rlc" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.ms-modi" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.net-fpx" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.wap.wbmp" = [ "org.gnome.Loupe.desktop" ];
         "image/vnd.xiff" = [ "org.gnome.Loupe.desktop" ];
         "image/webp" = [ "org.gnome.Loupe.desktop" ];
         "image/x-adobe-dng" = [ "org.gnome.Loupe.desktop" ];
         "image/x-canon-cr2" = [ "org.gnome.Loupe.desktop" ];
         "image/x-canon-crw" = [ "org.gnome.Loupe.desktop" ];
         "image/x-cmu-raster" = [ "org.gnome.Loupe.desktop" ];
         "image/x-cmx" = [ "org.gnome.Loupe.desktop" ];
         "image/x-epson-erf" = [ "org.gnome.Loupe.desktop" ];
         "image/x-freehand" = [ "org.gnome.Loupe.desktop" ];
         "image/x-fuji-raf" = [ "org.gnome.Loupe.desktop" ];
         "image/x-icns" = [ "org.gnome.Loupe.desktop" ];
         "image/x-icon" = [ "org.gnome.Loupe.desktop" ];
         "image/x-kodak-dcr" = [ "org.gnome.Loupe.desktop" ];
         "image/x-kodak-k25" = [ "org.gnome.Loupe.desktop" ];
         "image/x-kodak-kdc" = [ "org.gnome.Loupe.desktop" ];
         "image/x-minolta-mrw" = [ "org.gnome.Loupe.desktop" ];
         "image/x-nikon-nef" = [ "org.gnome.Loupe.desktop" ];
         "image/x-olympus-orf" = [ "org.gnome.Loupe.desktop" ];
         "image/x-panasonic-raw" = [ "org.gnome.Loupe.desktop" ];
         "image/x-pcx" = [ "org.gnome.Loupe.desktop" ];
         "image/x-pentax-pef" = [ "org.gnome.Loupe.desktop" ];
         "image/x-pict" = [ "org.gnome.Loupe.desktop" ];
         "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-rgb" = [ "org.gnome.Loupe.desktop" ];
         "image/x-sigma-x3f" = [ "org.gnome.Loupe.desktop" ];
         "image/x-sony-arw" = [ "org.gnome.Loupe.desktop" ];
         "image/x-sony-sr2" = [ "org.gnome.Loupe.desktop" ];
         "image/x-sony-srf" = [ "org.gnome.Loupe.desktop" ];
         "image/x-xbitmap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-xpixmap" = [ "org.gnome.Loupe.desktop" ];
         "image/x-xwindowdump" = [ "org.gnome.Loupe.desktop" ];

         "video/3gpp" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/3gpp2" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/h261" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/h263" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/h264" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/jpeg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/jpm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/mj2" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/mp2t" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/ogg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/quicktime" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/vnd.fvt" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/vnd.mpegurl" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/vnd.ms-playready.media.pyv" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/vnd.vivo" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/webm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-f4v" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-fli" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-flv" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-m4v" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-ms-asf" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-ms-wm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-ms-wmv" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-ms-wmx" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-ms-wvx" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-msvideo" = [ "io.github.celluloid_player.Celluloid.desktop" ];
         "video/x-sgi-movie" = [ "io.github.celluloid_player.Celluloid.desktop" ];

         "text/html" = [ "brave-browser.desktop" ];
         "x-scheme-handler/http" = [ "brave-browser.desktop" ];
         "x-scheme-handler/https" = [ "brave-browser.desktop" ];
         "x-scheme-handler/about" = [ "brave-browser.desktop" ];
         "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
      };
   };
}
