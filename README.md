# Debian 12 安装搜狗拼音输入法

本仓库提供在 Debian 12 上安装和配置搜狗拼音输入法（sogoupinyin）的步骤与修复脚本。

## 文件说明

| 文件 | 说明 |
|------|------|
| `sogoupinyin_4.2.1.145_amd64.deb` | 搜狗拼音输入法安装包（从 [Release](https://github.com/mars-base/sogoupinyin-debian/releases/tag/v4.2.1.145) 下载） |
| `sogoupinyin-fix.sh` | 系统库链接修复脚本 |

## 安装步骤

### 1. 移除其他输入法框架

```bash
sudo apt purge ibus
sudo apt purge fcitx5
```

### 2. 安装 fcitx

```bash
sudo apt install fcitx
```

### 3. 下载并安装搜狗拼音 deb 包

从 [Release 页面](https://github.com/mars-base/sogoupinyin-debian/releases/tag/v4.2.1.145) 下载 `sogoupinyin_4.2.1.145_amd64.deb`，然后安装：

```bash
sudo dpkg -i sogoupinyin_4.2.1.145_amd64.deb
sudo apt install -f  # 修复依赖错误
```

### 4. 安装 Qt5 运行库

搜狗拼音需要 qt5 库支持：

```bash
sudo apt install libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1
```

### 5. 修复系统库链接

搜狗拼音自带的 Qt5 库可能与 Debian 12 系统库不兼容，导致输入法无法启动或界面异常。`sogoupinyin-fix.sh` 会将 `/opt/sogoupinyin/files/lib/qt5/` 下的相关库链接到系统库。

#### 使用方法

```bash
sudo bash sogoupinyin-fix.sh
```

#### 脚本说明

- 需要 **root 权限**运行。
- 运行前会检查 `/opt/sogoupinyin/files/lib/qt5/` 是否存在，确保搜狗拼音已安装。
- 如果某个系统库不存在，脚本会跳过该库并输出警告，不会中断执行。
- 修复完成后，重新登录系统即可生效。

## 系统配置

### GNOME 设置

1. 打开 **Settings > Keyboard > Input Sources**，添加 **Chinese**。
2. 打开 **Tweaks > Keyboard & Mouse**，勾选 **Show Extended Input Sources**。

### Fcitx 配置

1. 打开 `fcitx configuration`。
2. 进入 **Addon**：
   - 勾选**高级**
   - 取消 **Classic**
   - 点击 **configuration** 配置
3. 回到 **Input Method** 界面，点击 `+` 号，搜索 `sogoupinyin` 并添加。

## 使用

注销并重新登录系统后，即可使用：

- `Ctrl + 空格`：调出搜狗拼音输入法
- `Shift`：切换到英文输入

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + Space` | 切换搜狗拼音输入法 |
| `Shift` | 中/英文切换 |
