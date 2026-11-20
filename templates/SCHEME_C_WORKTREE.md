# 方案 C：并行隔离约定

只在多个模型或会话会同时改同一 Git 仓库时启用。先有方案 B 的契约文件，再加本约定。

## 原则

- 每个模型 / 会话使用独立的 Git worktree 和分支，不要共用同一工作区改同一批文件。
- 官方机制见：https://git-scm.com/docs/git-worktree
- Claude Code 也提供 `--worktree` 隔离会话：https://code.claude.com/docs/en/worktrees

## 推荐流程

1. 从主工作区更新主线分支。
2. 为本次任务创建 worktree 和分支，例如：

```bash
git worktree add ../project-t001 -b agent/t001
cd ../project-t001
```

3. 在 `STATE.md` 的分区表里认领该 worktree / 分支和任务 ID。
4. 只在自己的 worktree 里改代码。契约文件（`STATE.md`、`tasks.json`、`DECISIONS.md`）仍以主工作区或事先约定的单一副本为真相；不要在多个 worktree 里各写各的任务单。
5. 本分支自测通过后，由**唯一集成者**（项目负责人，或其指定的一个模型）合入主线，并更新 `STATE.md` 与任务证据。合入后先对照 `AGENTS.md` / `DECISIONS.md` 检查规则与代码是否冲突；若有过时条款，追加 `N-xxx` 并提出退役草案，不要把冲突规则留在入口文件里。

## 不要做的事

- 不要两个模型在同一个工作目录里同时改同一文件
- 不要各自直接推 `main`
- 不要把未复验的分支标成已合入
