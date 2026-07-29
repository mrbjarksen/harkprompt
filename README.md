# The Hark prompt for Zsh

An aesthetic prompt with components for user, host, path, git status and jobs
as well as exit status, completion time and duration of last command. This
prompt is theme-able. You can invoke it thus:
```
$ prompt hark [<theme>]
```
Supported themes are:
* default
* catppuccin-mocha

The default theme uses terminal colors, while other themes assume 24-bit true
color support. Nerd Fonts support is assumed.

## Preview

Screenshot of terminal output of `prompt -p hark`
in Kitty with Catppuccin Mocha colors
(not shown are exit code and background jobs components):

<img width="788" height="428" alt="prompt preview output" src="https://github.com/user-attachments/assets/3c4f570c-ebf6-4c01-85d4-c78fc85d74db" />

## Installation

### Manual

To install manually, clone the repository (or download `prompt_hark_setup`) and place somewhere convenient:
```
$ git clone https://github.com/mrbjarksen/harkprompt
$ mv harkprompt <DESIRED LOCATION>
```
Then add the following to `.zshrc`:
```zsh
fpath+=(<PATH TO harkprompt DIRECTORY>)
setopt TRANSIENT_RPROMPT
autoload -U promptinit && promptinit
prompt hark <DESIRED THEME>
```

### Nix flake

This project exposes a Nix flake, defining a package, overlay, NixOS module and home-manager module.
Add it as a flake input and use the provided overlay to add the package to your nixpkgs instance. Example:
```nix
{
  inputs = {
    nixpkgs.url = "...";
    harkprompt = {
      url = "github:mrbjarksen/harkprompt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, harkshell, ... }:
    let
      system = "...";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ harkprompt.overlays.default ];
      };
    in
    { ... };
}
```

The NixOS and home-manager modules provide options under `programs.zsh.harkprompt`. Example:
```nix
{ config, lib, pkgs, ... }: {
  programs.zsh.harkprompt = {
    enable = true;
    package = pkgs.harkprompt;
    theme = "catppuccin-mocha";
  };
}
```

## Extra configuration

The following environment variables may be used to configure the prompt further:
* `PROMPT_HARK_SHLVL_OFFSET`: Value is added to `$SHLVL` to adjust how many prompt characters appear before input
