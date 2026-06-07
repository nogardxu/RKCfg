# RKCfg

这个仓库保存 `fish`、`tmux`、`herdr`、`starship` 配置副本，以及新设备初始化脚本。

## 目录

- `dotfiles/`: 仓库内维护的配置副本
- `scripts/`: 安装和初始化脚本

## 使用

交互式初始化（逐项 y/N 选择要配置的组件；未勾选就跳过，即使本机已安装也不会覆盖）：

```bash
./scripts/bootstrap.sh
```

非交互式按组件初始化：

```bash
./scripts/bootstrap.sh fish tmux herdr
./scripts/bootstrap.sh herdr
```

只安装单项：

```bash
./scripts/install-fish.sh
./scripts/install-tmux.sh
./scripts/install-herdr.sh
```

## 脚本会做什么

- 自动安装基础依赖：`fish`、`tmux`、`git`、`curl`，以及 Linux 剪贴板工具 `wl-clipboard`、`xclip`、`xsel`
- 按 Starship 官方安装脚本安装 `starship`
- 把仓库内配置软链到官方默认目录 `~/.config` 和 `~/.tmux`
- 备份已有同名文件到 `~/.rkcfg-backups/<timestamp>/`
- 按 Fisher 官方安装方式安装 `fisher`
- 按 TPM 官方安装方式安装 `tpm`，并自动执行命令行插件安装
- 按 Catppuccin 官方推荐方式把 tmux 主题安装到 `~/.config/tmux/plugins/catppuccin`
- 按 Herdr 官方安装脚本安装 `herdr`
- 为 Herdr 安装 `omp`、`codex`、`opencode` integrations，并链接仓库内的 Herdr 配置

## 说明

- 仓库只保存真正需要版本管理的配置文件。
- `fish_variables`、插件生成的 `functions/`、`completions/` 没有纳入版本库。
- tmux 配置会同时链接到 `~/.config/tmux/tmux.conf` 和 `~/.tmux.conf`，兼容官方默认路径和传统路径。
- `starship` 和 `tmux` 状态栏里用了 Nerd Font 图标；如果终端里图标显示异常，换用 Nerd Font 即可。
- tmux 复制会按环境自动使用 `clip.exe`（WSL）、`wl-copy`（Wayland）、`xclip` / `xsel`（X11）或 `pbcopy`（macOS）。
- Herdr 安装脚本会在检测到运行中的 Herdr server 时自动执行 `herdr server reload-config`。