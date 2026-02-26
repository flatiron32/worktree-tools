# worktree-tools

Repository-agnostic worktree CLI utilities.

## Commands
- wt-init
- wt-create
- wt-switch
- wt-list
- wt-status
- wt-sync
- wt-remove
- wt-cleanup

## Install

```bash
./install.sh
```

## Current Implemented Commands

### wt-init
```bash
wt-init <repo-url> [workspace-dir] [--repo-name <name>] [--yes]
```
Creates:
- `<workspace>/<repo_name>/bare.git`
- `<workspace>/<repo_name>/main`
- `<workspace>/<repo_name>/branches`

If the target repo container already exists and is clean, `wt-init` can replace it with `--yes` (or via interactive confirmation in a TTY session).

### wt-create
```bash
wt-create <branch-name> [--repo <repo-root>]
```
Outputs created path on stdout.

### wt-switch
```bash
wt-switch [branch-name|path] [--repo <repo-root>]
```
Outputs resolved path on stdout.

### wt-list
```bash
wt-list [--repo <repo-root>] [--json]
```

### wt-status
```bash
wt-status [--repo <repo-root>] [--json]
```

### wt-sync
```bash
wt-sync [--repo <repo-root>] [--rebase] [--dry-run] [--yes]
```

### wt-remove
```bash
wt-remove <branch-name|path> [--repo <repo-root>] [--dry-run] [--yes] [--delete-branch]
```

### wt-cleanup
```bash
wt-cleanup [--repo <repo-root>] [--dry-run] [--yes]
```
Removes merged feature worktrees and keeps dirty merged worktrees in place for manual review.

## Development

- Use small conventional commits (for example: `feat: add wt-sync dry-run mode`, `fix: resolve wt-init relative path`).
- Prefer one focused change per commit.
- Run test scripts in `tests/` before committing.

## Test Coverage Notes

- `wt-remove` protects the `main` worktree.
- `wt-cleanup` skips dirty merged worktrees, removes clean merged worktrees, and exits non-zero when any dirty merged worktree is skipped.
