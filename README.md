# RKCfg

这个仓库保存 `fish`、`tmux`、`starship` 配置副本，以及新设备初始化脚本。

## 目录

- `dotfiles/`: 仓库内维护的配置副本
- `scripts/`: 安装和初始化脚本

## 使用

全量初始化：

```bash
./scripts/bootstrap.sh
```

只安装 Shell / 美化配置：

```bash
./scripts/install-fish.sh
```

只安装 tmux 配置：

```bash
./scripts/install-tmux.sh
```

## 脚本会做什么

- 自动安装基础依赖：`fish`、`tmux`、`starship`、`git`、`curl`
- 把仓库内配置软链到 `$HOME` 或 `$XDG_CONFIG_HOME`
- 备份已有同名文件到 `~/.rkcfg-backups/<timestamp>/`
- 自动安装 `fisher`、`tpm`、`catppuccin/tmux`、`tmux-sensible`、`tmux-yank`

## 说明

- 仓库只保存真正需要版本管理的配置文件。
- `fish_variables`、插件生成的 `functions/`、`completions/` 没有纳入版本库。
- `starship` 和 `tmux` 状态栏里用了 Nerd Font 图标；如果终端里图标显示异常，换用 Nerd Font 即可。

