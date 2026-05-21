---
name: commit
description: Git commit workflow with safety checks and validation
version: 1.0.0
author: opencode

## Overview

This skill provides a comprehensive Git commit workflow with safety checks to prevent common mistakes and ensure high-quality commits.

## Features

- **Safety Protocol**: Prevents destructive Git operations unless explicitly requested
- **Commit Validation**: Checks for secrets, empty commits, and improper configurations
- **Automated Analysis**: Analyzes changes and drafts appropriate commit messages
- **Hook Handling**: Properly handles pre-commit hooks and rejects failed commits
- **Branch Protection**: Warns about force pushes to main/master branches

## Usage

### When to use this skill

Activate this skill when you need to:
- Create new Git commits
- Amend existing commits (with proper validation)
- Handle pre-commit hook failures
- Validate commit content for security issues
- Ensure proper commit message formatting

### How to use

1. The skill will automatically activate when Git commit operations are requested
2. All Git operations will be carefully reviewed against the safety protocol
3. Commits will be analyzed for content, quality, and security before execution
4. Failed commits will be properly handled without force amendments

## Safety Protocol Rules

### Never perform these operations:
- Update Git configuration (git config)
- Run destructive/irreversible commands (git push --force, hard reset, etc.)
- Skip hooks (--no-verify, --no-gpg-sign)
- Force push to main/master branches
- Commit files that likely contain secrets (.env, credentials.json, etc.)
- Amended commits that have been pushed to remote (unless explicitly requested)

### Commit Validation Rules:

1. **Empty Commits**: Do not create empty commits unless specifically requested
2. **Secret Detection**: Scan for and warn about potential secrets
3. **File Analysis**: Analyze all staged changes to understand their purpose
4. **Message Quality**: Ensure commit messages are meaningful and follow conventions
5. **Hook Compliance**: Respect pre-commit hook failures

### Amend Rules (ONLY use --amend when ALL conditions are met):
1. User explicitly requested amend, OR the commit succeeded and pre-commit hooks auto-modified files that need including
2. HEAD commit was created by you in this conversation (verify: git log -1 --format='%an %ae')
3. Commit has NOT been pushed to remote (verify: git status shows "Your branch is ahead")
4. If commit FAILED or was REJECTED by hook, NEVER amend - fix the issue and create a NEW commit

## Workflow

### Standard Commit Process:

1. **Status Check**: Run `git status` to see all untracked files
2. **Diff Analysis**: Run `git diff` to see staged and unstaged changes
3. **History Review**: Run `git log` to understand recent commit messages
4. **Staging**: Add relevant untracked files to staging area
5. **Message Drafting**: Analyze changes and draft appropriate commit message
6. **Execution**: Create the commit with a proper message
7. **Verification**: Run `git status` to verify success

### Failed Commit Handling:

1. **Analyze Failure**: Determine why the commit failed
2. **Fix Issues**: Address the specific problems that caused failure
3. **New Commit**: Create a NEW commit (do not amend failed commits)
4. **Retry**: Attempt the commit again

### Branch Protection:

1. **Main/Master Detection**: Check if current branch is main/master
2. **Force Push Warning**: Warn user if they request force push to protected branches
3. **Safety Confirmation**: Require explicit confirmation for sensitive operations

## Integration with opencode

This skill integrates with opencode to provide:
- Interactive commit workflow
- Automated change analysis
- Safety checks and validations
- Proper error handling and recovery

## Error Handling

- **Hook Failures**: Fix the issue and create a new commit (do not amend)
- **Validation Errors**: Prevent commits that violate safety rules
- **Configuration Issues**: Warn about improper Git setup
- **Network Issues**: Handle remote operation failures gracefully

## Best Practices

- Always provide clear, concise commit messages
- Follow the project's commit message conventions
- Review changes before committing
- Never skip pre-commit hooks
- Use Git responsibly and safely

## Examples

### Good Commit:
```
git add src/new-feature.js
git commit -m "feat: add new feature to improve user experience"
```

### Bad Commit (to be prevented):
```
git commit --no-verify -m "fix stuff"  # Skips hooks
git push --force origin main           # Force push to main
```

## Support

For issues with this skill, please report at: https://github.com/anomalyco/opencode/issues