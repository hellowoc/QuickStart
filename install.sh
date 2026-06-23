#!/bin/bash
# ==============================================
# QuickStart 实习生入职系统 一键安装脚本
# 仓库: https://github.com/hellowoc/QuickStart
# ==============================================

set -e

SKILL_DIR="$HOME/.claude/skills/onboarding"
REPO_URL="https://github.com/hellowoc/QuickStart.git"
TMP_DIR=$(mktemp -d)
SKILL_SRC="Claude_Memory_Shared/.claude/skills/onboarding/SKILL.md"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   QuickStart 实习生入职系统         ║"
echo "  ║   一键安装 + 个人信息录入           ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# ── 第一步：克隆仓库 ──
echo "[1/4] 拉取最新版本..."
git clone --depth 1 --branch main "$REPO_URL" "$TMP_DIR" 2>&1 | tail -1

# ── 第二步：安装 skill ──
echo "[2/4] 安装 onboarding skill..."
mkdir -p "$SKILL_DIR"
cp "$TMP_DIR/$SKILL_SRC" "$SKILL_DIR/SKILL.md"

# ── 第三步：个人信息面试 ──
echo "[3/4] 个人信息录入..."
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │         个人信息面试                    │"
echo "  │   请回答以下 5 个问题                   │"
echo "  └─────────────────────────────────────────┘"
echo ""

read -p "  1. 怎么称呼你？（如 张工、小李）: " CALLNAME
read -p "  2. 学校 & 专业 & 学历？: " EDU
read -p "  3. C / C++ / Qt / Linux / 网络 / 调试 各自什么水平？（熟练/入门/零基础）: " TECHS
read -p "  4. 你习惯怎么学新代码？（先看文档 / 先跑起来 / 先看结构图）: " LEARNSTYLE
read -p "  5. 和 AI 交流偏好？（简短直给 / 详细解释 / 先框架后细节）: " AISTYLE
read -p "  实习开始日期？（如 2026-07-01）: " STARTDATE
read -p "  预计考核日期？（如 2026-09-30）: " ENDDATE

PROFILE_DIR="$HOME/.claude/skills/onboarding"
cat > "$PROFILE_DIR/profile.local.md" << PROFILE
---
generated_by: QuickStart install.sh
install_date: $(date +%Y-%m-%d)
---

# 个人信息

## 称呼
$CALLNAME

## 教育背景
$EDU

## 技术栈自评
$TECHS

## 学习偏好
$LEARNSTYLE

## AI 交流偏好
$AISTYLE

## 实习信息
- 实习开始日期: $STARTDATE
- 预计考核日期: $ENDDATE
- 当前阶段: 环境搭建

PROFILE

echo ""
echo "  ✓ profile.local.md 已生成"

# ── 第四步：创建个人知识目录 ──
echo "[4/4] 创建个人知识目录..."
PERSONAL_NAME=$(echo "$CALLNAME" | tr ' ' '_')
MDDATA_DIR="$HOME/mddata_$PERSONAL_NAME"
mkdir -p "$MDDATA_DIR/模块笔记"
mkdir -p "$MDDATA_DIR/踩坑记录"

echo "# $CALLNAME 的学习路线" > "$MDDATA_DIR/学习路线.md"
echo "" >> "$MDDATA_DIR/学习路线.md"
echo "实习开始: $STARTDATE" >> "$MDDATA_DIR/学习路线.md"
echo "预计考核: $ENDDATE" >> "$MDDATA_DIR/学习路线.md"
echo "" >> "$MDDATA_DIR/学习路线.md"
echo "## 负责模块" >> "$MDDATA_DIR/学习路线.md"
echo "" >> "$MDDATA_DIR/学习路线.md"
echo "（待选择，对 AI 说\"帮我选择负责的模块\"）" >> "$MDDATA_DIR/学习路线.md"

echo "# 踩坑记录" > "$MDDATA_DIR/踩坑记录.md"
echo "" >> "$MDDATA_DIR/踩坑记录.md"
echo "| 日期 | 问题 | 原因 | 解决方案 | 耗时 |" >> "$MDDATA_DIR/踩坑记录.md"
echo "|------|------|------|---------|------|" >> "$MDDATA_DIR/踩坑记录.md"

# ── 清理 ──
rm -rf "$TMP_DIR"

# ── 验证 ──
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║         安装完成！                  ║"
echo "  ╠══════════════════════════════════════╣"
echo "  ║  Skill:   $SKILL_DIR                ║"
echo "  ║  个人信息: $PROFILE_DIR/profile.local.md ║"
echo "  ║  个人目录: $MDDATA_DIR              ║"
echo "  ╠══════════════════════════════════════╣"
echo "  ║  下一步:                            ║"
echo "  ║  1. 重启 Claude Code                ║"
echo "  ║  2. 执行 /reload-skills             ║"
echo "  ║  3. 对 AI 说: 带我认识 QuickStart   ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
