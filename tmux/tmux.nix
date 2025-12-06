{ pkgs, configDir, ... }:
{
  programs.my-tmux = {
    enable = true;
    configuration = ''
      # Set fish as default shell and default command
      set -g default-shell ${pkgs.fish}/bin/fish
      set -g default-command ${pkgs.fish}/bin/fish

      # Include my configuration
      source-file ${configDir}/tmux/custom.conf
    '';
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.better-mouse-mode;
        extraConfig = ''
          set -g @scroll-speed-num-lines-per-scroll 1
          set -g @emulate-scroll-for-no-mouse-alternate-buffer on
        '';
      }
    ];
  };
}
