# zsh-config

## Installation

Git, zsh, and curl are required. Run the bootstrap installer:

```sh
curl -fsSL https://raw.githubusercontent.com/sykuang/zsh-config/master/install.sh | zsh
```

The installer clones only the latest commit into `~/.config/zsh` and asks
whether to link `~/.zshrc` and the mise configuration. On macOS, it also asks
before installing `btop` when Homebrew is already available.

Existing files and symlinks are never overwritten, so the installer is safe to
run again.

### Optional Ubuntu build dependencies

```sh
sudo apt-get install build-essential gdb lcov pkg-config \
  libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
  libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
  lzma lzma-dev tk-dev uuid-dev zlib1g-dev
```
