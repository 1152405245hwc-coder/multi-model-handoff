# 多模型文件夹协作交接模板

把不同模型（Claude Code、Codex、Gemini、Antigravity、Cursor 等）在同一项目文件夹里的交接，从聊天窗口搬到固定契约文件。用单一状态真相、追加决策 / 否决记录，以及可复验的交棒现场，串起主线，减少重复劳动、互相覆盖和假完成。

维护者：[1152405245hwc-coder](https://github.com/1152405245hwc-coder)

本仓库提供可复制的空白模板和初始化脚本。把它用到你的项目时，运行 `init-handoff.sh` 即可；默认不覆盖已有文件。

## 方案怎么选

| 方案 | 适合 | 核心文件 | 什么时候用 |
| --- | --- | --- | --- |
| A | 非 Git 文件夹，或轻量调研、宣发、视频工程 | `AGENTS.md`、`STATE.md`、`HANDOFF.md`、`DECISIONS.md` | 大约五分钟上手。为了能退役过时规则，A 也包含 `DECISIONS.md`。 |
| B（推荐主力） | 持续推进的代码仓，或复杂内容项目 | 在 A 之上加 `tasks.json` / `TASKS.md` | 有任务认领、验收证据和否决记录。 |
| C | 两个以上模型会同时改同一 Git 仓库 | 在 B 之上加 `SCHEME_C_WORKTREE.md` | 用 worktree / 分支隔离，由唯一集成者合入主线。 |

建议先用 A 或 B，真并行时再升级到 C。不要把本模板直接混进无关的业务仓库，也不要用它覆盖已有项目里的契约文件（脚本默认跳过已存在文件）。

## 快速初始化

```bash
git clone https://github.com/1152405245hwc-coder/multi-model-handoff.git
cd multi-model-handoff
chmod +x init-handoff.sh

# 方案 A
./init-handoff.sh /path/to/project a

# 方案 B（默认）
./init-handoff.sh /path/to/project
./init-handoff.sh /path/to/project b

# 方案 C
./init-handoff.sh /path/to/project c

# 明确要求覆盖同名文件时才加 --force（危险）
# ./init-handoff.sh /path/to/project b --force
```

二次执行同一目录时，已存在的文件会被跳过，不会覆盖你已经填过的内容。

初始化之后：先填写 `STATE.md` 的北极星、阶段和不做清单，再把 `START_PROMPT.md` 里的开场口令发给新模型。

## Trace → Distill → Prune

每棒都走一遍这个低成本闭环，而不是另外上一套重型框架。

1. **Trace（留痕）**  
   记录尝试、关键决策、失败原因、验证结果，以及为何改向。`HANDOFF.md` 只保留当前现场；重写前把上一份追加到 `logs/handoff-archive/`。归档是证据，不是当前真相。

2. **Distill（提炼）**  
   只把已经验证、而且会反复出现的规律、约束和流程，做成准备写进 `AGENTS.md` 的短条款。晋升必须经人工确认。一次失败不要写成长期规则。

3. **Prune（修剪）**  
   过时、重复、冲突或不再适用的指导，先退役到 `DECISIONS.md` 的 `N-xxx`（否决区或「已退役规则 / Lessons Retired」），再从 `AGENTS.md` / `STATE.md` 删除或替换。`AGENTS.md` 只准替换或经确认后晋升，不准无限追加。

可选：规则明显膨胀或与代码不一致时，可由人工决定是否运行 `npx unrot check`。这不是默认依赖。

## 交接与收尾口令

完整原文见 `templates/START_PROMPT.md` 和 `templates/END_PROMPT.md`。初始化到项目后，这两份会一起拷过去。

**开场（不要只说“继续”）**

- 先不要改任何文件。按 `AGENTS.md` → `STATE.md` → `DECISIONS.md` → `HANDOFF.md` → 任务单的顺序只读。
- 不要把 `logs/handoff-archive/` 当作当前事实。
- 先汇报北极星、主线是否已被认领、哪些路径已否决或退役、上一棒何事已实测或未实测、`AGENTS.md` 是否看起来过时，以及你准备认领的任务和第一个动作。等确认后再动手。

**收尾（一棒结束、切模型或离开前）**

- 先把旧的 `HANDOFF.md` 归档，再整份重写为当前现场。
- 更新 `STATE.md` 和任务状态；未实测不得标完成。
- 新的决策、否决和规则退役追加到 `DECISIONS.md`，不改写旧条目。
- 列出建议晋升或退役的 `AGENTS.md` 条款，等人工确认后再改入口文件。
- 未经要求，不要推远程或开 PR。

## 目录

- `templates/`：空白模板（含 `logs/handoff-archive/` 归档说明）
- `init-handoff.sh`：按方案拷贝模板
- `LICENSE`：MIT 协议

## 署名与协议

本模板由 GitHub 账号 [1152405245hwc-coder](https://github.com/1152405245hwc-coder) 维护，采用 [MIT License](LICENSE) 开源。
