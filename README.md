# research-workflow

A reusable research workflow skill for Codex: organize papers, baseline reproduction, experiments, and handoffs in project files.

一个面向 **Codex** 的科研工作流技能：通过项目文档承载文献、复现、实验与交接，让新的聊天能继续已有工作。核心使用通用 `SKILL.md` 格式，脚本与模板不依赖 Claude 专属工具。

## 安装到 Codex

需要能够读取本地文件、执行 Bash 的 Codex 环境。克隆仓库需要 Git；下载论文还需要网络访问及 curl、tar、gzip、Perl。macOS 通常自带这些脚本工具，Windows 可在 WSL 中使用。

以下安装位置依据 [Codex 官方技能文档](https://learn.chatgpt.com/docs/build-skills)。选择个人安装或项目安装中的一种，避免同名技能重复出现。

### 方式一：个人安装，所有项目可用

在终端执行：

```bash
mkdir -p ~/.agents/skills
git clone https://github.com/BradSun233/research-workflow.git ~/.agents/skills/research-workflow
```

安装后的入口是 `~/.agents/skills/research-workflow/SKILL.md`。`~` 表示当前用户的主目录，例如 macOS 上的 `/Users/你的用户名`；以 `.` 开头的目录在 Finder 中默认隐藏，可用 `Command + Shift + .` 显示。

### 方式二：项目安装，仅在该项目中使用

先进入你的课题目录，例如 IP 项目，再执行：

```bash
cd /你的路径/IP
mkdir -p .agents/skills
git clone https://github.com/BradSun233/research-workflow.git .agents/skills/research-workflow
```

将示例路径替换为真实项目路径。安装后结构如下：

```text
IP/
└── .agents/skills/research-workflow/
    ├── SKILL.md
    ├── agents/openai.yaml
    ├── scripts/
    └── assets/templates/
```

如需把技能随 IP 仓库一起提交，建议复制完整技能目录（不要复制其 `.git`）或明确使用 Git submodule；直接 clone 的目录是嵌套仓库，不能按普通目录直接提交。

### 已经下载源码：使用本地链接

macOS / Linux 可以保留已有源码位置，以符号链接注册。例如源码已放在桌面：

```bash
mkdir -p ~/.agents/skills
ln -s "$HOME/Desktop/research-workflow" "$HOME/.agents/skills/research-workflow"
```

运行前确认链接目标位置尚不存在。该方式不复制文件，修改源码即修改技能。项目中也可以创建本地链接，但它依赖本机路径，不适合直接分享给其他人。

### 确认安装与更新

Codex 会自动检测技能变化；未出现时重启 Codex。CLI / IDE 扩展可通过 `/skills` 或输入 `$` 查找 `research-workflow`；其他界面可直接在请求中写“使用 research-workflow 技能”。

通过 Git 克隆安装的版本可在保留本地修改的前提下更新：

```bash
git -C ~/.agents/skills/research-workflow pull --ff-only
```

项目安装时替换为项目中的技能路径；链接安装时在源码仓库更新。下载 ZIP 的版本需手动替换文件。仓库地址：[BradSun233/research-workflow](https://github.com/BradSun233/research-workflow)。

## 使用

安装让 Codex 能发现技能，不会自动启动训练或执行整套流程。可以明确调用，也可以让 Codex 根据请求与 `description` 匹配。

明确调用：

```text
$research-workflow 在当前目录初始化一个时间序列异常检测课题。
```

或者直接说：

```text
使用 research-workflow 技能，帮我建立当前科研项目的文献和实验记录。
```

首次初始化会收集尚未提供的研究问题、目标与期限、领域术语，然后建目录并填写模板。目标还没确定时可以写“待定”。请在实际课题目录使用，技能源码目录只存放流程、脚本和模板。

后续请求示例：

```text
使用 research-workflow，把 arXiv 2301.11305 下载到当前课题的 related_work。
使用 research-workflow，记录这次实验的配置、结果和失败原因。
使用 research-workflow，先读项目说明和交接记录，再继续上次的复现。
使用 research-workflow，更新交接文档，列出已经验证的结论和下一步。
```

自动匹配示例：“给这个科研课题补一份实验记录”。普通代码修改和非科研请求不应触发这个技能。下载论文与运行实验仍受当前 Codex 环境的网络、文件和执行权限约束。

## 生成的课题结构

```text
你的课题/
├── AGENTS.md              课题背景、目录约定、项目规则
├── handoff.md             当前进度、证据、下一步
├── brainstorm.md          问题、假设与设计依据
├── related_work/          每篇 paper.pdf 与可用的 source/
├── 复现/                  baseline 复现及报告
├── experiment/
│   ├── results.md         各版实验记录
│   └── evaluation.md      固定测评口径
├── DataSet/               数据目录
└── dataset.md             数据及处理说明
```

已有项目只补缺失文件，保留原有结构与规则。`AGENTS.md` 是项目说明，skill 是跨项目复用的方法；技能安装本身不会生成这些课题文件。测评、结果和交接文档由 Codex 按任务读取，不会全都自动加载。

建议节奏是“抓文献 → 复现关键 baseline → 提假设 → 跑实验 → 迭代”。用户只请求其中一步时，执行该步即可。实验记录保留失败与作废原因；区分论文报告值、本地实测值和未验证假设。

## 手动运行脚本

通常让 Codex 调用即可，也可以自己运行。以下使用个人安装路径：

```bash
bash "$HOME/.agents/skills/research-workflow/scripts/init-project.sh" "$HOME/Code/my-paper"
```

脚本只复制缺失模板，不覆盖已有文件；它不会自动填写研究背景或运行实验，生成后需由你或 Codex 填写文档。

下载论文时先进入课题目录，因为输出写在当前目录的 `related_work/`：

```bash
cd "$HOME/Code/my-paper"
bash "$HOME/.agents/skills/research-workflow/scripts/fetch-paper.sh" 2301.11305 detectgpt
```

可使用带版本的 ID，例如 `2301.11305v1`。不传第二个参数时，目录名使用 ID。源码不一定公开；脚本会尝试获取，并保留清洗前的 `.orig` 文件。隔离旧稿和剥离注释都是启发式操作，查关键数字、公式时应核对目标版本 PDF。

## 仓库内容

```text
research-workflow/
├── SKILL.md               技能入口、触发范围与执行说明
├── agents/openai.yaml     Codex 技能展示信息
├── scripts/               项目初始化与论文下载
├── assets/templates/      复制到课题中的文档模板
└── README.md              安装与使用说明
```

不需要额外安装 MCP 服务或打包为插件就能本地使用此技能。其他支持 Agent Skills 的工具可复用核心内容，但技能发现位置和调用方式以各工具文档为准。
