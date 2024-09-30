{ config, pkgs, ... }:

{
   home.username = "george";
   home.homeDirectory = "/home/george";

   home.stateVersion = "24.05";

   home.packages = with pkgs; [
      gnomeExtensions.tiling-assistant
      gnomeExtensions.no-overview
      gnomeExtensions.alphabetical-app-grid
   ];

   # Use `dconf watch /` to track stateful changes you are doing and store them here.
   dconf = {
      enable = true;
      settings = {
         "org/gnome/TextEditor" = {
            highlight-current-line = true;
            show-line-numbers = true;
            indent-style = "space";
            tab-width = 4;
            auto-indent = true;
            show-map = true;
         };

         "org/gnome/desktop/wm/preferences" = {
            focus-mode = "sloppy";
         };

         "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
               pkgs.gnomeExtensions.tiling-assistant.extensionUuid
               pkgs.gnomeExtensions.no-overview.extensionUuid
               pkgs.gnomeExtensions.alphabetical-app-grid.extensionUuid
            ];
         };

         "org/gnome/mutter" = {
            # edge-tiling = false; # Windows-like window snapping
            dynamic-workspaces = true;
            attach-modal-dialogs = true;
         };

         "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = 0.0;
         };

         "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark"; # Dark theme
            enable-hot-corners = false;
            gtk-theme = "adw-gtk3-dark";
            font-antialiasing = "rgba";
            monospace-font-name = "JetBrainsMono Nerd Font 14";
            show-battery-percentage = true;
            clock-show-weekday = true;
            clock-format = "12h";
         };

         # Set wallpaper
         "org/gnome/desktop/background" = {
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
            primary-color = "#241f31";
         };

         "org/gnome/desktop/screensaver" = {
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            primary-color = "#241f31";
         };

         # Add minimize and maximize buttons to GNOME titlebar
         "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
         };

         "org/gtk/settings/file-chooser" = {
            clock-format = "12h";
         };

         "org/gnome/desktop/datetime" = {
            automatic-timezone = true;
         };
      };
   };

   home.file = {};
   home.sessionVariables = {};

   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;

   # Enable and setup Git.
   programs.git = {
      enable = true;
      userName = "George McCarthy";
      userEmail = "mccarthee@outlook.com";
   };

   # Enable and setup Codium.
   programs.vscode = {
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
            fontFamily =  "'JetBrainsMono Nerd Font', monospace";
            tabSize = 3;
            detectIndentation = false;
            cursorBlinking = "expand";
            cursorSmoothCaretAnimation = "on";
            formatOnSave = true;
            semanticHighlighting.enabled = true;
         };

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
         (catppuccin.catppuccin-vsc.override {})
         catppuccin.catppuccin-vsc-icons
      ];
   };
}
