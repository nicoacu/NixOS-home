`sudo nano /etc/nixos/configuration.nix/` to install pkgs

`sudo nixos-rebuild --upgrade-all switch` to make the package manager rebuild the system with the new changes (and the --upgrade-all to update packages)

`nix-shell -p <list of packages>` to create ephimeral shells with the packages included in the list. once you exit the shell they no longer exist in the system (good option to try a program before installing it)



additional stuff: 

```
nix-env --upgrade some-packages
nix-env --rollback
```

```
nix-env --unistall firefox # package isn't deleted right away as it might be needed for a rollback
nix-collect-garbage # deletes all packages that aren't in use by any user profile or by a currently running program
```
