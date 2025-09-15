{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zsh;
in
{
  options = {
    programs.zsh = {
      powerlevel10k.enable = lib.mkEnableOption "Whether to enable powerlevel10k for zsh";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.zsh = {
          enableCompletion = true;
          initContent = lib.mkMerge [
            # initExtraBeforeCompInit
            (lib.mkOrder 550 ''
              setopt notify
              unsetopt beep
              bindkey -e
            '')
            (builtins.readFile ../../../.extra.zsh)
          ];
        };

        home.packages = with pkgs; [
          eza
          fd
          ripgrep
          sd
        ];
      }
      (lib.mkIf cfg.powerlevel10k.enable {
        home.packages = [
          pkgs.zsh-powerlevel10k
        ];
        home.file.".p10k.zsh".source = ../../../.p10k.zsh;
        programs.zsh.initContent = lib.mkMerge [
          # initExtraFirst
          (lib.mkBefore ''
            # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
            # Initialization code that may require console input (password prompts, [y/n]
            # confirmations, etc.) must go above this block; everything else may go below.
            if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
          '')
          ''
            source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
            # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
            [[ ! -f "''${HOME}/.p10k.zsh" ]] || source "''${HOME}/.p10k.zsh"
          ''
        ];
      })
    ]
  );
}
