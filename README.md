# nixos-config
My NixOS configuration files. To make them work on a specific device (desktop
or Thinkpad T480) make sure to create a `machine.nix` file in
`~/.config/nixpkgs` and `/etc/nixos` that contains:
```nix
{
    imports = [
        ./machines/device.nix
    ];
}
```
substitute `device` with `t480` or `desktop`.
