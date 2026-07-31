{
  description = "An aesthetic component-based prompt for Zsh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }:
    let
      forEachUnixSystem = withPkgs:
        nixpkgs.lib.genAttrs
          nixpkgs.lib.platforms.unix
          (system:
            let
              pkgs = import nixpkgs { inherit system; };
            in
              withPkgs pkgs
          );
    in
    {
      packages = forEachUnixSystem (pkgs: {
        default = pkgs.callPackage ./package.nix { };
        harkprompt = pkgs.callPackage ./package.nix { };
      });

      overlays.default = self.overlays.harkprompt;
      overlays.harkprompt = final: prev: {
        harkprompt = prev.callPackage ./package.nix { };
      };

      nixosModules.default = self.nixosModules.harkprompt;
      nixosModules.harkprompt = { config, lib, pkgs, ... }: {
        meta.maintainers = with nixpkgs.lib.maintainers; [ mrbjarksen ];
        options.programs.zsh.harkprompt = {
          enable = lib.mkEnableOption "the hark prompt for Zsh";
          package = lib.mkPackageOption pkgs "harkprompt" { };
          theme = lib.mkOption {
            type = lib.types.str;
            default = "default";
            description = "The theme to pass to harkprompt";
          };
        };
        config = {
          programs.zsh.promptInit = lib.mkIf config.programs.zsh.harkprompt.enable ''
            fpath+=(${config.programs.zsh.harkprompt.package}/share/zsh/site-functions)

            setopt TRANSIENT_RPROMPT
            PROMPT_HARK_SHLVL_OFFSET=-1

            autoload -U promptinit && promptinit
            prompt hark ${config.programs.zsh.harkprompt.theme}
          '';
        };
      };

      homeModules.default = self.homeModules.harkprompt;
      homeModules.harkprompt = { config, lib, pkgs, ... }: {
        meta.maintainers = with nixpkgs.lib.maintainers; [ mrbjarksen ];
        options.programs.zsh.harkprompt = {
          enable = lib.mkEnableOption "the hark prompt for Zsh";
          package = lib.mkPackageOption pkgs "harkprompt" { };
          theme = lib.mkOption {
            type = lib.types.str;
            default = "default";
            description = "The theme to pass to harkprompt";
          };
        };
        config = {
          programs.zsh.initContent = lib.mkIf config.programs.zsh.harkprompt.enable ''
            fpath+=(${config.programs.zsh.harkprompt.package}/share/zsh/site-functions)

            setopt TRANSIENT_RPROMPT
            PROMPT_HARK_SHLVL_OFFSET=-1

            autoload -U promptinit && promptinit
            prompt hark ${config.programs.zsh.harkprompt.theme}
          '';
        };
      };
    };
}
