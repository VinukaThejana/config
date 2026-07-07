{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    jorgelbg-tap = {
      url = "github:jorgelbg/homebrew-tap";
      flake = false;
    };
    asmvik-tap = {
      url = "github:asmvik/homebrew-formulae";
      flake = false;
    };
    # zathura-tap = {
    #   url = "github:homebrew-zathura/homebrew-zathura";
    #   flake = false;
    # };
    hashicorp-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    jorgelbg-tap,
    asmvik-tap,
    # zathura-tap,
    hashicorp-tap,
    ...
  }:
  let
    configuration = { pkgs, ... }: {
      system.primaryUser = "vinuka";
      users.users.vinuka.home = "/Users/vinuka";
      nixpkgs.config.allowUnfree = true;

      # Disable all documentation engines
      documentation.enable = false;
      documentation.doc.enable = false;
      documentation.man.enable = false;
      documentation.info.enable = false;

      # Cleaned, de-duplicated, and sorted list of system packages
      environment.systemPackages = with pkgs; [
        # --- Development Toolchains & Runtimes ---
        cmake
        cocoapods
        go
        gradle
        jdt-language-server # Formerly `jdtls` from Homebrew
        jdk          # A more generic alias for `openjdk`
        lua
        luajit
        maven
        nodejs
        php
        pnpm
        python3
        ruby
        rustup
        tree-sitter

        # -- CLI user applications --
        bat
        biome
        carapace
        chezmoi
        curl
        diff-so-fancy
        dprint
        entr
        eza
        fd
        fzf
        glow
        htop
        jq
        just
        lazydocker
        lazygit
        lf
        mpg123
        neovim
        nushell
        p7zip
        ripgrep
        skim
        starship
        html-tidy
        tmux
        unzip
        wget
        yazi
        google-cloud-sdk
        ngrok
        deno

        # --- Version Control ---
        git
        gh
        jj

        # --- Services & Networking ---
        doppler
        flyctl
        gnupg
        grpcurl
        redis
        rtorrent
        sqlc
        sqlite       # Provides the `sqlite3` CLI
        postgresql_17
        usql

        # --- Media & Document Processing ---
        ffmpeg
        ghostscript
        hadolint
        imagemagick
        jpegoptim
        libwebp
        poppler      # Provides PDF tools like `pdftotext`
        resvg        # For SVG rendering
        tesseract
        yt-dlp
        pandoc
      ];

      homebrew = {
        enable = true;

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;

        casks = [
          #-- Development Tools--
          "1password"
          "1password-cli"
          "orbstack"
          "android-commandlinetools"
          "android-platform-tools"
          "apidog"
          "ghostty"
          "tableplus"
          "balenaetcher"
          "postman"
          "kindavim"
          "zed"
          "rar"
          "redis-insight"
          "visual-studio-code"
          "programmer-dvorak"

          #-- SDKs and Runtimes --
          "dotnet-sdk"

          #-- Note taking and Productivity --
          "notion"
          "zoom"

          #-- AI --

          #-- Social Media--
          "telegram"

          #-- Document and PDF Management --

          #-- Entetainment --
          "spotify"
          "stremio"
          "iina"
          "plex"

          #-- 3D Printing--
          "bambu-studio"
          "openscad"
          "autodesk-fusion"
          "freecad"

          #-- System Utilities --
          "anydesk"
          "windows-app"
          "obs"
          "paragon-ntfs"

          #-- Cloud storage --
          "google-drive"

          #-- VPN --
          "windscribe"
        ];
        brews = [
          #-- Window Management --
          "asmvik/formulae/skhd"

          #-- Development Toolchains & Runtimes --
          "php-code-sniffer"
          "protobuf"
          "protoc-gen-go"
          "coreutils"
          "pv"
          "openssl"
          "terraform-ls"
          "hashicorp/tap/terraform"
          "pkg-config-wrapper"

          #-- AI --
          "gemini-cli"

          #-- Media & Document Processing --
          "jpeg-xl"

          #-- Wine --
          "cabextract"
          "zenity"

          #-- Languages --
          "zig"

          #-- CLI user applications --
          "iredis"
          "mas"
          "atuin"
          "opensca-cli"
          "stripe-cli"
          "xh"
          "aria2"
          "git-filter-repo"
          "telnet"
          "git-filter-repo"
          "exiftool"
          "arduino-cli"
          "tectonic"
          "rclone"

          # Zathura and its plugins
          # "homebrew-zathura/zathura/zathura"
          # "homebrew-zathura/zathura/zathura-cb"
          # "homebrew-zathura/zathura/zathura-djvu"
          # "homebrew-zathura/zathura/zathura-pdf-mupdf"
          # "homebrew-zathura/zathura/zathura-pdf-poppler"
          # "homebrew-zathura/zathura/zathura-ps"

          #-- Tocuh ID and Security --
          "pinentry"
          "pinentry-mac"
          "pinentry-touchid"

          #-- Cloud providers --
          "awscli"
        ];

        masApps = {
          #-- Safari Extensions --
          "1Password for Safari" = 1569813296;
          "AdGuard for Safari" = 1440147259;
          "Refined GitHub" = 1519867270;

          #-- Social Media -- 
          "Slack for Desktop" = 803453959;
          "WhatsApp" = 310633997;

          #-- Utility Applications --
          "HP" = 1474276998;
          "Keynote" = 409183694;
          "Numbers" = 409203825;
          "Pages" = 409201541;
          "Xcode" = 497799835;
          "Blackmagic Disk Speed Test" = 425264550;

          #-- Entetainment Applications --
          "Rippple 2" = 6758765611;

          #-- Creative Applications--
          "Canva" = 897446215;
          "GarageBand" = 682658836;
        };
      };

      fonts.packages = [ ];

      system.defaults = {
        #--- Dock related settings--
        dock.autohide = true;
        dock.persistent-apps = [
            "/Applications/Safari.app"
            "/Applications/Ghostty.app"
            "/System/Applications/Mail.app"
            "/System/Applications/System Settings.app/"
            "/System/Applications/iPhone Mirroring.app/"
        ];
        dock.show-recents = true;

        #-- Finder related settings--
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;
        finder._FXShowPosixPathInTitle = true;
      };

      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Vinukas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "vinuka";
            mutableTaps = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "jorgelbg/tap" = jorgelbg-tap;
              "asmvik/formulae" = asmvik-tap;
              # "homebrew-zathura/zathura" = zathura-tap;
              "hashicorp/homebrew-tap" = hashicorp-tap;
            };

            trust = {
                taps = [
                  "jorgelbg/tap"
                  "asmvik/formulae"
                  # "homebrew-zathura/zathura"
                  "hashicorp/homebrew-tap"
                ];
            };
          };
        }
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })

        home-manager.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vinuka = import ./home.nix;
        }
      ];
    };
  };
}
