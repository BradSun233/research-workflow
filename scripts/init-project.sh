#!/bin/bash
# 建一个科研项目的骨架。
#
#   ./init-project.sh ~/Code/my-new-paper
#   ./init-project.sh .                     # 在当前目录建
#
# 已存在的文件不会被覆盖——在已有项目里跑也安全，只补缺的。

set -euo pipefail

DEST="${1:?用法: init-project.sh <项目目录>}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$SCRIPT_DIR/../assets/templates"

mkdir -p "$DEST"/{related_work,复现,experiment,DataSet}
cd "$DEST"

put() { # $1=模板名 $2=目标路径
  if [ -e "$2" ]; then
    echo "  ·  $2  已存在，跳过"
  else
    cp "$TPL/$1" "$2"
    echo "  +  $2"
  fi
}

put AGENTS.md      AGENTS.md
put handoff.md     handoff.md
put brainstorm.md  brainstorm.md
put dataset.md     dataset.md
put results.md     experiment/results.md
put evaluation.md  experiment/evaluation.md

# .gitignore：数据和大文件别进版本库
if [ ! -e .gitignore ]; then
  cat > .gitignore <<'EOF'
DataSet/
related_work/*/paper.pdf
related_work/*/source/
experiment/*/checkpoints/
experiment/*/*.pt
*.orig
.shot-tmp/
__pycache__/
EOF
  echo "  +  .gitignore"
fi

cat <<EOF

骨架建好了：$(pwd)

下一步按顺序：

  1. 填 AGENTS.md 的 {{占位符}} —— 尤其是研究问题与待验证假设，
     未确定的目标写待定，未运行的实验不要填入实测数字

  2. 抓文献：
       cd "$(pwd)"
       bash "$SCRIPT_DIR/fetch-paper.sh" <arxiv-id> <目录名>

  3. **先复现再找问题** —— 挑两三篇有开源代码的跑通，写 复现/<方法>/复现报告.md
     论文只报平均和成功配置，卡在哪、哪个 setting 崩了，只有自己跑才看得见

  4. 复现跑完之后再进 brainstorm.md 提假设

每个窗口结束前更新 handoff.md。
EOF
