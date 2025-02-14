{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.vscode.enable = true;
  programs.vscode = {
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
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zsh-powerlevel10k
    inputs.zen-browser.packages."${system}".default
  ];

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;

  #   oh-my-zsh = {
  #     enable = true;
  #     # theme = "powerlevel10k/powerlevel10k";
  #     plugins = [
  #       "git"
  #       "docker"
  #       "docker-compose"
  #       "kubectl"
  #       "helm"
  #       "aws"
  #       "gcloud"
  #     ];
  #     theme = "robbyrussell";
  #   };
  # };

  /*
  The home.stateVersion option does not have a default and must be set
  */
  home.stateVersion = "23.11";
  /*
  Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ];
  */
}
