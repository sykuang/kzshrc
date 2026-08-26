# zsh-config

## Installation

Zsh and curl are required. Run the bootstrap installer:

```sh
curl -fsSL https://raw.githubusercontent.com/sykuang/zsh-config/master/install.sh | zsh
```

The installer clones only the latest commit into `~/.config/zsh` and asks
whether to link the zsh configuration (`~/.zshrc`, `~/.p10k.zsh`, and
`~/.autoenv.zsh`) and the mise configuration. If mise is unavailable, the
installer installs it from `https://mise.run`. When linked, mise installs the
configured command-line tools. Zim and its modules are installed automatically
on the first shell startup. On macOS, the installer installs Homebrew and Git
when unavailable, then asks before installing `btop`.

Existing files and symlinks are never overwritten, so the installer is safe to
run again.

### Optional Ubuntu build dependencies

```sh
sudo apt-get install build-essential gdb lcov pkg-config \
  libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
  libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
  lzma lzma-dev tk-dev uuid-dev zlib1g-dev
```
