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

  xdg.configFile."lazydocker" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lazydocker";
    recursive = true;
  };

  xdg.configFile."lazygit" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lazygit";
    recursive = true;
  };

  xdg.configFile."lf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lf";
    recursive = true;
  };

  xdg.configFile."1Password" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/1Password";
    recursive = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/nvim";
    recursive = true;
  };

  xdg.configFile."glow" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/glow";
    recursive = true;
  };

  xdg.configFile."htop" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/htop";
    recursive = true;
  };

  xdg.configFile."skhd" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/skhd";
    recursive = true;
  };

  xdg.configFile."tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/tmux";
    recursive = true;
  };

  xdg.configFile."yabai" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/yabai";
    recursive = true;
  };

  xdg.configFile."yazai" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/yazai";
    recursive = true;
  };
}
