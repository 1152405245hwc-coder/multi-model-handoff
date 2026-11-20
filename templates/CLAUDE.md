@AGENTS.md

# Claude Code 专用补充

只放 Claude Code 需要的额外说明。跨工具规则一律写在 `AGENTS.md`。

若本仓库已经依赖 `AGENTS.md`，不要再另写一份完整的 `CLAUDE.md`，否则默认设置下 Claude Code 可能只读 `CLAUDE.md`、不再直接读取 `AGENTS.md`。需要同时保留本地个人说明时，把 Project instructions 设为 `claude-md-and-agents-md`，或始终用上面的 `@AGENTS.md` 导入。
