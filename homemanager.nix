{
  inputs,
  config,
  pkgs,
  ...
}: let
  #system = "x86_64-linux"; # for zen https://medium.com/@notquitethereyet_/installing-zen-browser-on-nixos-%EF%B8%8F-7ae541f5533f
  lib = pkgs.lib;
  #home-manager = builtins.fetchTarball {
  #  url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  #  sha256 = "00wp0s9b5nm5rsbwpc1wzfrkyxxmqjwsc1kcibjdbfkh69arcpsn";
  #};
  ### workaround to install Obsidian https://forum.obsidian.md/t/electron-25-is-now-eol-please-upgrade-to-a-newer-version/72878/7
  #  obsidian = lib.throwIf (lib.versionOlder "1.4.16" pkgs.obsidian.version) "Obsidian no longer requires EOL Electron" (
  #    pkgs.obsidian.override {
  #      electron = pkgs.electron_25.overrideAttrs (_: {
  #        preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
  #        meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
  #      });
  #    }
  #  );
  ###
in {
  #imports = [
  #  (import "${home-manager}/nixos")
  #];

  home-manager.users.nacuna = {
    nixpkgs.config.allowUnfree = true;

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
        eamodio.gitlens
        golang.go
        mikestead.dotenv
        yzhang.markdown-all-in-one
        bbenoist.nix
        kamadorueda.alejandra
        ms-python.python
        esbenp.prettier-vscode
        oderwat.indent-rainbow
        tamasfe.even-better-toml
        #pomdtr.excalidraw-editor
        #vsliveshare.vsliveshare
        ## Github Copilot stuff
        github.copilot
        github.copilot-chat
      ];
      #        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #          {
      #            name = "codeium";
      #            publisher = "Codeium";
      #            version = "1.7.38";
      #            sha256 = "sha256-bT+9nlhj0trX1lfCdYsbsrF2SCONyPaC7cqJtm13AYw=";
      #          }
      #        ];
    };

    programs.firefox = {
      enable = true;
      #  profiles."nacuna" = {
      #    extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
      #      ublock-origin
      #    ];
      #  };
    };

    #    programs.kitty = {
    #      enable = true;
    #      theme = "Wild Cherry";
    #      keybindings = {
    #        "ctrl+c" = "copy_or_interrupt";
    #        "ctrl+v" = "paste_from_clipboard";
    #        "ctrl+l" = "scroll-and-clear-screen";
    #      };
    #    };

    #    programs.bash = {
    #      enable = true;
    #      shellAliases = {
    #        ssh = ''kitty +kitten ssh'';
    #      };
    #    };

    /*
    The home.stateVersion option does not have a default and must be set
    */
    home.stateVersion = "23.11";
    /*
    Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
    */

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".specific
    ];
  };
}
