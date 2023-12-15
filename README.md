## Draft

Pkgs can be found at https://search.nixos.org

`sudo nano /etc/nixos/configuration.nix/` to install pkgs

`sudo nixos-rebuild --upgrade-all switch` to make the package manager rebuild the system with the new changes (and the --upgrade-all to update packages)

`nix-shell -p <list of packages>` to create ephemeral shells with the packages included in the list. once you exit the shell they no longer exist in the system (A good option if you want to try a program before installing it)

## Home-manager

_(Notice that most commands should be run with sudo as home-manager interacts with configuration.nix, which is placed at /etc/nixos)_

Check the Nixpkgs version being currently followed with:

```
sudo nix-channel --list
```

Then try to find a matching release from home-manager, for example, for Nixpkgs version 23.11:

```
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --update
```

Then, if the home-manager is loaded as a NixOS module, check that the configuration.nix has the home.stateVersion specified. e.g:

```
home-manager.users.${user} = { pkgs, ... }: {

    home.packages = with pkgs; [ vscode ]
    home.stateVersion = "23.11"; 

  };
```

Once this is done, just `nixos-rebuild` all over again.

More info at: https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module

## Additional stuff: 

```
nix-env --upgrade some-packages
nix-env --rollback
```

```
nix-env --list-generations # see all generations
nix-env --unistall firefox # package isn't deleted right away as it might be needed for a rollback
nix-collect-garbage # deletes all packages that aren't in use by any user profile or by a currently running program
sudo nix-collect-garbage -d #remove ALL but current generation (generation = NixOS snapshots basically) 
```

Good vod to have as a reference: https://youtube.com/watch?v=AGVXJ-TKv3Y
