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
wt-init <repo-url> [workspace-dir]
```
Creates:
- `<workspace>/<repo_name>/bare.git`
- `<workspace>/<repo_name>/main`
- `<workspace>/<repo_name>/branches`

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

## Development

- Use small conventional commits (for example: `feat: add wt-sync dry-run mode`, `fix: resolve wt-init relative path`).
- Prefer one focused change per commit.
- Run test scripts in `tests/` before committing.
