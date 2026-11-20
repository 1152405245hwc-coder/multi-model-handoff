#!/usr/bin/env bash
# 把空白交接模板按方案 A / B / C 拷到目标项目目录。
# 已存在的文件默认跳过，不会覆盖。
#
# 用法：
#   ./init-handoff.sh /path/to/project
#   ./init-handoff.sh /path/to/project b
#   ./init-handoff.sh /path/to/project --scheme c
#   ./init-handoff.sh /path/to/project a --force
#
# 方案默认为 b。--force 会覆盖同名文件（危险，需明确传入）。

set -euo pipefail

usage() {
  echo "用法: $0 /path/to/project [a|b|c] [--scheme a|b|c] [--force]" >&2
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

TARGET_ARG=""
SCHEME="b"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    --scheme)
      if [[ $# -lt 2 ]]; then
        usage
      fi
      SCHEME="$2"
      shift 2
      ;;
    --scheme=*)
      SCHEME="${1#--scheme=}"
      shift
      ;;
    -h|--help)
      usage
      ;;
    a|b|c|A|B|C)
      if [[ -z "$TARGET_ARG" ]]; then
        # A path named "a" is extremely unlikely as the only arg meaning scheme;
        # if target is already set, treat as scheme.
        echo "错误: 请先给出目标目录，再写方案 a|b|c" >&2
        usage
      fi
      SCHEME=$(echo "$1" | tr '[:upper:]' '[:lower:]')
      shift
      ;;
    *)
      if [[ -z "$TARGET_ARG" ]]; then
        TARGET_ARG="$1"
        shift
      else
        echo "错误: 无法识别的参数: $1" >&2
        usage
      fi
      ;;
  esac
done

if [[ -z "$TARGET_ARG" ]]; then
  usage
fi

SCHEME=$(echo "$SCHEME" | tr '[:upper:]' '[:lower:]')
if [[ "$SCHEME" != "a" && "$SCHEME" != "b" && "$SCHEME" != "c" ]]; then
  echo "错误: 方案必须是 a、b 或 c，收到的是: $SCHEME" >&2
  exit 1
fi

if [[ ! -d "$TARGET_ARG" ]]; then
  mkdir -p "$TARGET_ARG"
fi
TARGET=$(cd "$TARGET_ARG" && pwd)

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$SCRIPT_DIR/templates"

if [[ ! -d "$SRC" ]]; then
  echo "找不到模板目录: $SRC" >&2
  exit 1
fi

# 所有方案共用的契约与口令。方案 A 也包含 DECISIONS.md，作为否决和规则退役的落点。
COMMON_FILES=(
  "AGENTS.md"
  "STATE.md"
  "HANDOFF.md"
  "DECISIONS.md"
  "CLAUDE.md"
  "GEMINI.md"
  ".gemini-settings.json.example"
  "START_PROMPT.md"
  "END_PROMPT.md"
  "logs/handoff-archive/README.md"
)

FILES=("${COMMON_FILES[@]}")
if [[ "$SCHEME" == "b" || "$SCHEME" == "c" ]]; then
  FILES+=("TASKS.md")
fi
if [[ "$SCHEME" == "c" ]]; then
  FILES+=("SCHEME_C_WORKTREE.md")
fi

copy_one() {
  local src_rel="$1"
  local dest_rel="${2:-$1}"
  local src="$SRC/$src_rel"
  local dest="$TARGET/$dest_rel"
  if [[ ! -f "$src" ]]; then
    echo "缺少模板文件: $src_rel" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && $FORCE -ne 1 ]]; then
    echo "跳过已存在: $dest_rel"
    skipped=$((skipped + 1))
    return
  fi
  cp "$src" "$dest"
  echo "写入: $dest_rel"
  copied=$((copied + 1))
}

copied=0
skipped=0

echo "方案: $SCHEME"
echo "目标目录: $TARGET"
echo

for rel in "${FILES[@]}"; do
  copy_one "$rel"
done

if [[ "$SCHEME" == "b" || "$SCHEME" == "c" ]]; then
  # 任务单在目标目录里使用正式文件名 tasks.json
  copy_one "tasks.example.json" "tasks.json"
fi

# 确保归档目录存在（即使 README 被跳过）
mkdir -p "$TARGET/logs/handoff-archive"

echo
echo "新写入 $copied 个文件，跳过 $skipped 个已存在文件。"
echo "下一步："
echo "  1. 先改 STATE.md 的北极星目标和当前里程碑"
echo "  2. 用 START_PROMPT.md 里的接棒开场口令开工"
echo "  3. 收尾时用 END_PROMPT.md：先把旧 HANDOFF.md 归档到 logs/handoff-archive/，再重写当前现场"
echo "  4. AGENTS.md 只准替换或经人工确认后晋升，过时规则退役到 DECISIONS.md 的 N-xxx"
