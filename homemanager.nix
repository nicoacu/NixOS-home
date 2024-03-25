{
  inputs,
  config,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

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
  };
}
