# dotfiles

Managed with [yadm](https://yadm.io/) (`$HOME` is the work tree) and
[mise](https://mise.jdx.dev/) (runtimes and CLI tools). No Homebrew.

## Setup on a fresh Mac

```shell
curl -fsSL https://raw.githubusercontent.com/datahaikuninja/dotfiles/main/bootstrap.sh | bash
```

1. `bootstrap.sh` checks Xcode Command Line Tools (for git), installs yadm into
   `~/.local/bin`, and runs `yadm clone`.
2. `yadm bootstrap` (`.config/yadm/bootstrap`) runs the rest:
   - sparse-checkout so that `README.md`, `bootstrap.sh` and `docs/` stay out of `$HOME`
   - Rosetta, mise + `mise install`, the gh-dash extension, git completion,
     the SKK dictionary, the HackGen font, Google Cloud SDK
   - prints the GUI apps and auth steps that still need to be done by hand

To try a branch: `curl ... | DOTFILES_BRANCH=<branch> bash`.

## Layout

| Path | Tool |
|---|---|
| `.zshrc` | zsh (zinit installs itself on first launch) |
| `.config/mise/config.toml` | mise global tools |
| `.config/nvim/` | Neovim |
| `.wezterm.lua` | WezTerm |
| `.config/starship.toml` | Starship |
| `.config/tmux/tmux.conf` | tmux |
| `.config/gh-dash/config.yml` | gh-dash |
| `Library/Application Support/lazygit/config.yml` | lazygit |
| `.hammerspoon/init.lua` | Hammerspoon |
| `.config/karabiner/assets/complex_modifications/` | Karabiner-Elements rules |

## Daily use

```shell
yadm status / yadm add <file> / yadm commit / yadm push
dotfiles   # cd ~ && yadm enter: subshell where nvim/lazygit see the yadm repo
ylg        # lazygit on the yadm repo

mise use -g <tool>@<version>   # add a tool (updates .config/mise/config.toml)
mise upgrade                   # upgrade tools pinned to "latest"
```

## Not covered by mise

- GUI apps: install from vendor sites (list printed by `yadm bootstrap`).
  OrbStack provides `docker`.
- MySQL client: `mysql80` / `mysql57` run in containers (see `.zshrc`).
