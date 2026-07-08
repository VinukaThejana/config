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

  home.file.".gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/git/gitconfig";
  };
  xdg.configFile."gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/git/identities";
    recursive = true;
  };

  home.file."bin" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/bin";
    recursive = true;
  };

  home.file."Library/Services" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/services";
    recursive = true;
  };

  home.file.".ssh/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/ssh/config";
  };

  xdg.configFile."carapace" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/carapace";
    recursive = true;
  };

  xdg.configFile."gh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/gh";
    recursive = true;
  };

  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/ghostty";
    recursive = true;
  };
}
