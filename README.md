# nix-config

Personal nix-darwin + Home Manager system configuration for macOS, with dotfiles and package management all declaratively managed in a single repo.

This repo declaratively manages:
- System packages (`environment.systemPackages`)
- Homebrew casks, brews, and Mac App Store apps (via `nix-homebrew`)
- macOS system defaults (Dock, Finder)
- User-level dotfiles and config, symlinked in via Home Manager (`home.nix`)

Most dotfiles are wired up using `config.lib.file.mkOutOfStoreSymlink`, which means the files under `~/.config/<tool>` (or `~/.gitconfig`, `~/.ssh/config`, etc.) are **symlinks pointing directly into this repo** — not copies baked into the Nix store. This means:

- You edit config files normally, wherever they "live" (e.g. `~/.config/nvim/init.lua`) — changes apply immediately, **no `darwin-rebuild switch` required**.
- A `darwin-rebuild switch` is only needed when you change the *structure* of `home.nix`/`flake.nix` itself (adding a new managed file, adding a package, etc.) — not for everyday dotfile edits.
- Since you're really editing files inside this repo (through the symlink), "backing up" a change is just committing and pushing:
  ```bash
  cd ~/.config/nix
  git add -A
  git commit -m "update nvim config"
  git push
  ```

### What's intentionally excluded (`.gitignore`)

- `config/tmux/plugins/` — these are clones managed by `tpm` (Tmux Plugin Manager). They're not tracked here; re-install them on a new machine via tpm's normal bootstrap (`prefix` + `I` inside tmux) rather than version-controlling someone else's plugin repos as embedded git repos.

---

## Cloning only a specific subfolder

If you only want a single tool's config (e.g. just `nvim`) without pulling the whole repo, use git's **sparse checkout**:

```bash
git clone --filter=blob:none --no-checkout https://github.com/VinukaThejana/config.git
cd config
git sparse-checkout init --cone
git sparse-checkout set config/nvim
git checkout main
```

This gives you a working copy containing only `config/nvim/` (plus the repo root files needed for git bookkeeping) — nothing else is downloaded to disk. To add another folder later:

```bash
git sparse-checkout add config/nushell
```

To go back to a full checkout of everything:

```bash
git sparse-checkout disable
```

Note: this is for **grabbing a single config on its own** — it will not give you a working `home.nix`/`flake.nix` since those reference all the other paths. For actually restoring your full system, do a normal full clone (see below).

---

## Restoring on a new machine

### 1. Install Nix

Using the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer) (recommended — handles flakes support and macOS quirks out of the box):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Or the official installer:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Restart your terminal after install.

### 2. Enable flakes (if not already handled by the installer)

Copy this repo's `nix.conf` into place:

```bash
mkdir -p ~/.config/nix
cp nix.conf /etc/nix/nix.conf   # or ~/.config/nix/nix.conf depending on install method
```

Or manually ensure `/etc/nix/nix.conf` (or `~/.config/nix/nix.conf`) contains:

```
experimental-features = nix-command flakes
```

### 3. Clone this repo to `~/.config/nix`

```bash
git clone https://github.com/VinukaThejana/config.git ~/.config/nix
```

(The flake and Home Manager config assume this exact path — `~/.config/nix` — since dotfile symlinks are built relative to `home.homeDirectory`.)

### 4. Update usernames/paths if this is a different user or hostname

Check and update in `flake.nix`:
- `system.primaryUser`
- `users.users.<username>.home`
- `nix-homebrew.user`
- `darwinConfigurations."<hostname>"`
- `home-manager.users.<username>`

And in `home.nix`:
- `home.username`
- `home.homeDirectory`

### 5. Install nix-darwin and activate

```bash
cd ~/.config/nix
nix run nix-darwin -- switch --flake .#<hostname>
```

(Replace `<hostname>` with whatever's declared in `darwinConfigurations` in `flake.nix` — e.g. `Vinukas-MacBook-Pro`.)

This first run will:
- Install nix-darwin itself
- Install all `environment.systemPackages`
- Bootstrap Homebrew and install all casks/brews/Mac App Store apps declared in `flake.nix`
- Activate Home Manager and symlink all dotfiles declared in `home.nix` into place

### 6. Subsequent rebuilds

Once nix-darwin is installed, use the normal command going forward:

```bash
sudo darwin-rebuild switch --flake ~/.config/nix#<hostname>
```

### 7. Post-restore manual steps

A few things aren't (and can't be) fully automated by this flake:

- **tmux plugins**: open tmux and press `prefix` + `I` to have `tpm` install all plugins declared in `tmux.conf`.
- **1Password / SSH keys / GPG keys**: this repo does not contain secrets. Sign into 1Password and re-provision SSH/GPG keys separately.
- **Mac App Store apps** (`masApps`): you must be signed into the App Store with the Apple ID that owns those app licenses before `darwin-rebuild switch` can install them via `mas`.
- **Homebrew tap trust**: some taps require Rosetta (`enableRosetta = true` is already set) — if you're on Apple Silicon this is handled automatically, but the first Homebrew bootstrap can take a while as it installs Rosetta-side dependencies.
