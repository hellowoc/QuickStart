# QuickStart — 实习生入职系统

> 欢迎！如果你是新人，按下面的步骤走，AI 会在每个阶段协助你。

## 第一步：环境准备

```bash
git clone https://github.com/hellowoc/QuickStart.git
cd QuickStart
bash install.sh
```

安装脚本会自动：
- 部署 onboarding skill
- 启动个人信息面试（AI 问你答）
- 生成 `profile.local.md`
- 创建你的个人知识目录 `~/mddata_你的名字/`

安装完成后重启 Claude Code，对 AI 说：**"带我认识 QuickStart"**

---

## 第二步：认识知识库

对 AI 说：**"带我认识 ZKDataBase"**

AI 会引导你：
1. 阅读 `_主线_/` 下的工程概述，建立全局认知
2. 了解 `_模块_/` 的目录结构
3. 明白三区架构（主线 / 模块 / 个人）的使用规则

看完后对 AI 说：**"搭建开发环境"**，AI 会根据知识库中的工程信息指导你。



---

## 第三步：开始深度学习

在ZKDataBase中有引导文件，跟着这些引导文件对整个工程有个详细了解

在此过程中，你会与ai交互产生很多md文档，将他们保存到 `~/mddata_你的名字/`中

按照你自己的学习习惯，做好分类和管理

当metor让你重点学习某一个模块时，你可以将对该模块的深入学习导入到`~/mddata_你的名字/负责模块`中

---

## 第四步：独立负责

开始独立处理模块相关的问题和需求。过程中：

- 遇到的问题，解决过程 → 记入 `~/mddata_你的名字/问题记录`
- 有价值的理解 → 署名发布到 ZKDataBase 的 `~/mddata_你的名字/个人理解` 目录

你可以根据akDataBase中的结构布局，也可以使用mddata_YourName中的默认结构来组织你自己的知识库

---

## 第五步：归档 & 考核

对 AI 说：**"实习期结束，帮我归档"**

AI 会自动：
1. 扫描你 `~/mddata_你的名字/` 下的所有产出
2. 标出有价值回流入主线的内容
3. 生成《归档建议》
4. 对照《实习考核清单》


---

## 全程 AI 辅助

| 你想做什么 | 对 AI 说 |
|-----------|---------|
| 了解工程整体 | "带我认识 ZKDataBase" |
| 开始深度学习 | "带我按 ZKDataBase 引导学习" |
| 深入某个点 | "细讲这个" |
| 停下来消化 | "停，我消化一下" |
| 临时问个无关问题 | "题外话：[问题]" |
| 实习结束归档 | "实习期结束，帮我归档" |

---

## 目录说明

```
QuickStart/
├── README.md                    ← 你在看这个
├── install.sh                   ← 一键部署
├── Claude_Memory_Shared/        ← AI 记忆 + onboarding skill
├── ZKDataBase/                  ← 技术知识库
│   ├── .obsidian                ← obsidian 配置
│   └── 【引导】xxxx_MOC          ← ZKDataBase 使用引导文件
├── mddata_YourName/             ← 实习生个人知识目录（安装后重命名为 mddata_称呼）
└── 归档/                        ← 往届实习生产出归档
```
