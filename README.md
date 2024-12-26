# NixOS notes for @nacuna



# Index


## Update with Flakes

> from within the directory where the flake resides (i.e: /etc/nixos)

```
sudo nix flake update
```

*That checks the repos specified in the inputs part of the flake.nix and looks for newer commits, then rewrites the flake.lock to reflect the change.*

*Then, is necessary to rebuild the system again*

```
sudo nixos-rebuild --flake .#roach switch
```

## Code Snippets explained

```flake.nix
outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
} @ inputs: { }
```

> Outputs: A function that, given an attribute set containing the outputs of each of the input flakes keyed by their identifier, yields the Nix values provided by this flake

> So, outputs = {}: {} is a function assigned to a key within the attribute set (which is the flake itself).

> The first pair of curly brackets {}: contains the function arguments, with the outputs provided by the other flakes (nixpkgs and home-manager found under respective urls listed in inputs).

> The second pair of curly brackets {} is an attribute set, which is also the outputs function body. It contains all the key-value pairs which are to be made available for the reference as a flake output, either for standalone consumption, or as an input within some other flake.

> In other words, first curly bracket is referencing the functions from the imported flakes, second curly bracket contains all the key-value pairs used to specify the desired configuration.

## Useful Sources

[How to convert default nixos to nixos with flakes](https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes)
[How to add Home-Manager to Nixos](https://drakerossman.com/blog/how-to-add-home-manager-to-nixos)


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

## How to add second hard drive HDD

(fstab can't be modified)

Check disks and partitions with:

```
fdisk -l
lsblk
```

Identify which partition you want to mount and then

```
mount /dev/sdb2 /home
nixos-generate-config
```

you will see this:

```
writing /etc/nixos/hardware-configuration.nix…
warning: not overwriting existing /etc/nixos/configuration.nix
```

which is expected (as configuration.nix shouldn't be modified by this). you can check if the disk is mounted in boot reading `hardware-configuration.nix`
finish with 

```
sudo nixos-rebuild switch
```

source: https://discourse.nixos.org/t/how-to-add-second-hard-drive-hdd/6132/1

### Other stuff

- passwordless openssh configurations: https://www.reddit.com/r/NixOS/comments/ebgezb/passwordless_ssh_authentication_in_nixos/

- to add maximize/minimize: gnome-tweaks in nix-shell (`nix-shell -p gnome.gnome-tweaks`)