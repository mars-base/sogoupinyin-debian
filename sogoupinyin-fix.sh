#!/bin/bash

# 修复搜狗拼音输入法在 Debian 12 上的 Qt5 库链接
# 将 /opt/sogoupinyin/files/lib/qt5/ 下的库指向系统库，避免版本不兼容

set -euo pipefail

SOGOU_QT_DIR="/opt/sogoupinyin/files/lib/qt5"
SYS_LIB_DIR="/usr/lib/x86_64-linux-gnu"
SYS_QT_PLUGIN_DIR="${SYS_LIB_DIR}/qt5/plugins"

# 检查是否以 root 身份运行
if [[ $EUID -ne 0 ]]; then
    echo "错误：本脚本需要 root 权限，请使用 sudo 运行。" >&2
    exit 1
fi

# 检查搜狗拼音是否已安装
if [[ ! -d "${SOGOU_QT_DIR}" ]]; then
    echo "错误：未找到 ${SOGOU_QT_DIR}，请先安装 sogoupinyin。" >&2
    exit 1
fi

# 创建系统库软链接
# 参数：源文件（系统库） 目标文件（搜狗目录）
link_lib() {
    local src="$1"
    local dst="$2"

    if [[ ! -e "${src}" ]]; then
        echo "警告：源文件不存在，跳过: ${src}" >&2
        return 0
    fi

    if [[ -L "${dst}" ]] || [[ -e "${dst}" ]]; then
        rm -f "${dst}"
    fi

    ln -s "${src}" "${dst}"
    echo "已链接: ${dst} -> ${src}"
}

# Qt5 核心库
link_lib "${SYS_LIB_DIR}/libQt5Core.so.5" "${SOGOU_QT_DIR}/lib/libQt5Core.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Gui.so.5" "${SOGOU_QT_DIR}/lib/libQt5Gui.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Widgets.so.5" "${SOGOU_QT_DIR}/lib/libQt5Widgets.so.5"
link_lib "${SYS_LIB_DIR}/libQt5DBus.so.5" "${SOGOU_QT_DIR}/lib/libQt5DBus.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Qml.so.5" "${SOGOU_QT_DIR}/lib/libQt5Qml.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Network.so.5" "${SOGOU_QT_DIR}/lib/libQt5Network.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Quick.so.5" "${SOGOU_QT_DIR}/lib/libQt5Quick.so.5"
link_lib "${SYS_LIB_DIR}/libQt5QuickWidgets.so.5" "${SOGOU_QT_DIR}/lib/libQt5QuickWidgets.so.5"
link_lib "${SYS_LIB_DIR}/libQt5Svg.so.5" "${SOGOU_QT_DIR}/lib/libQt5Svg.so.5"
link_lib "${SYS_LIB_DIR}/libQt5XcbQpa.so.5" "${SOGOU_QT_DIR}/lib/libQt5XcbQpa.so.5"

# 其他依赖库
link_lib "${SYS_LIB_DIR}/libFcitxQt5DBusAddons.so.1" "${SOGOU_QT_DIR}/lib/libFcitxQt5DBusAddons.so.1"
link_lib "${SYS_LIB_DIR}/libgsettings-qt.so.1" "${SOGOU_QT_DIR}/lib/libgsettings-qt.so.1"
link_lib "${SYS_LIB_DIR}/libpcre.so.3" "${SOGOU_QT_DIR}/lib/libpcre.so.3"

# Qt5 插件
link_lib "${SYS_QT_PLUGIN_DIR}/iconengines/libqsvgicon.so" "${SOGOU_QT_DIR}/plugins/iconengines/libqsvgicon.so"
link_lib "${SYS_QT_PLUGIN_DIR}/imageformats/libqsvg.so" "${SOGOU_QT_DIR}/plugins/imageformats/libqsvg.so"
link_lib "${SYS_QT_PLUGIN_DIR}/platforminputcontexts/libfcitxplatforminputcontextplugin.so" "${SOGOU_QT_DIR}/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so"
link_lib "${SYS_QT_PLUGIN_DIR}/platforms/libqlinuxfb.so" "${SOGOU_QT_DIR}/plugins/platforms/libqlinuxfb.so"
link_lib "${SYS_QT_PLUGIN_DIR}/platforms/libqminimal.so" "${SOGOU_QT_DIR}/plugins/platforms/libqminimal.so"
link_lib "${SYS_QT_PLUGIN_DIR}/platforms/libqoffscreen.so" "${SOGOU_QT_DIR}/plugins/platforms/libqoffscreen.so"
link_lib "${SYS_QT_PLUGIN_DIR}/platforms/libqxcb.so" "${SOGOU_QT_DIR}/plugins/platforms/libqxcb.so"
link_lib "${SYS_QT_PLUGIN_DIR}/xcbglintegrations/libqxcb-glx-integration.so" "${SOGOU_QT_DIR}/plugins/xcbglintegrations/libqxcb-glx-integration.so"

echo "搜狗拼音库链接修复完成。"
