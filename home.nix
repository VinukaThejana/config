{ pkgs, config, ... }:
{
  home.username = "vinuka";
  home.homeDirectory = "/Users/vinuka";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  xdg.configFile."nushell" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/nushell";
    recursive = true;
  };
}
