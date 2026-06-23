#!/bin/bash
# ==============================================
# 工程入门 skill 一键安装/更新脚本
# 来源: hellowoc/Claude_Memory (私有仓库)
#
# 用法:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/hellowoc/Claude_Memory/main/.claude/skills/onboarding/install.sh)"
#
# 前置条件:
#   git 已配置且有 hellowoc/Claude_Memory 仓库访问权限
#
# 更新（已安装后获取最新版）:
#   重新执行同一条命令即可覆盖安装
# ==============================================

set -e

SKILL_DIR="$HOME/.claude/skills/onboarding"
REPO_URL="https://github.com/hellowoc/Claude_Memory.git"
TMP_DIR=$(mktemp -d)
SKILL_SRC=".claude/skills/onboarding/SKILL.md"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   工程入门 skill 一键安装           ║"
echo "  ║   hellowoc/Claude_Memory            ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# 1. 浅克隆仓库（利用已有 git 认证，SSH 或 HTTPS token）
echo "[1/4] 克隆仓库（depth=1）..."
git clone --depth 1 --branch main "$REPO_URL" "$TMP_DIR" 2>&1 | tail -1

# 2. 创建 skill 目录
echo "[2/4] 创建目录: $SKILL_DIR"
mkdir -p "$SKILL_DIR"

# 3. 复制 SKILL.md
echo "[3/4] 安装 SKILL.md ..."
cp "$TMP_DIR/$SKILL_SRC" "$SKILL_DIR/SKILL.md"

# 4. 清理临时目录
echo "[4/4] 清理临时文件..."
rm -rf "$TMP_DIR"

# 验证
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    LINES=$(wc -l < "$SKILL_DIR/SKILL.md")
    echo ""
    echo "  ✓ 安装成功！"
    echo "  ├─ 位置: $SKILL_DIR/SKILL.md"
    echo "  ├─ 行数: $LINES"
    echo "  └─ 来源: $REPO_URL"
    echo ""
    echo "  ▸ 下一步: 在 Claude Code 中执行 /reload-skills 或重启 Claude Code"
    echo ""
else
    echo "  ✗ 安装失败"
    echo "  请检查:"
    echo "    1. git 是否有 hellowoc/Claude_Memory 的访问权限"
    echo "    2. 网络是否正常"
    exit 1
fi
