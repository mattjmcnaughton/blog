---
name: code-review
description: Perform a flexible code review with configurable depth and focus
---

Perform a code review on the provided or specified code changes. The review adapts its depth and focus based on the review mode.

## Output Location
- **Default**: `.agentic-wip/code-review.md`
- Before writing, check if `.agentic-wip/` directory exists; create it if not
- **Fallback**: If file writing is unavailable (e.g., running in CI/GitHub Actions), output the review directly in the conversation
- User may specify an alternative output path explicitly

## Input Understanding
Parse the user's message to identify:

- **Review Mode**: The depth and focus of the review
  - Look for explicit mode names: "iteration", "standard", "critical", "security"
  - Look for phrases indicating depth: "quick review", "thorough review", "security check", "deep dive"
  - **Default**: Standard mode if not specified

- **Code Source**: What code to review (one of the following):
  - **Direct diff**: A diff pasted directly in the message
  - **PR reference**: "PR #123", "pull request 456", or a GitHub PR URL
  - **File paths**: "review src/auth/*.ts", "check the changes in lib/utils.js"
  - **Branch comparison**: "changes from main to feature-branch", "diff between develop and release"
  - **Commit range**: "commits abc123..def456", "last 3 commits"
  - **Recent changes**: "uncommitted changes", "staged changes", "working directory"
  - If not specified, assume uncommitted changes in the current directory

- **Specific Focus**: Additional areas to emphasize
  - Look for phrases like "focus on error handling", "pay attention to performance", "check the API contracts"
  - This is optional and supplements the review mode

## Examples of Natural Input
- "Review the changes"
- "Code review PR #142"
- "Quick iteration review of src/new-feature/"
- "Critical review of the payment processing changes"
- "Security review https://github.com/org/repo/pull/89"
- "Review the diff between main and my-branch, focus on error handling"
- "Review last 5 commits with security focus"
- "Standard review of uncommitted changes in src/api/"
- (A diff pasted directly with no other instructions)

## Process

1. **Determine Review Mode**
   - Parse the user's message for mode indicators
   - If not explicitly specified, select mode based on context:
     - **Iteration**: Pre-1.0 projects or early-stage development
     - **Standard**: Post-1.0 projects (the typical default)
     - **Critical**: Code that is particularly complex or impacts critical systems
     - **Security**: Code that handles authentication, authorization, user input, or sensitive data

2. **Identify and Retrieve Code**
   - Determine the code source from the input
   - For PR references: fetch the diff using appropriate tools (gh CLI or MCP)
   - For file paths: read the files and identify recent changes
   - For branch/commit comparisons: use git diff
   - For direct diffs: parse the provided diff content

3. **Gather Context**
   - Identify test files related to the changed code
   - Find callers/consumers of modified functions or APIs
   - Examine imports and dependencies
   - Check for related documentation files
   - Look for agent instruction files that may contain project-specific conventions or requirements:
     - `CLAUDE.md` and `AGENTS.md` files in the repository root or relevant directories
     - Rules files in directories like `.claude/rules/*.md`, `.cursor/rules/*.md`, or similar
     - Use these instructions to inform the review (e.g., project conventions, prohibited patterns, required practices)

4. **Perform Review Based on Mode**
   - Apply the appropriate depth and focus for the selected mode (see Review Mode Details below)
   - Examine the code through the lens of the mode's priorities

5. **Run Standard Checks**
   - **Test Coverage**: Are there tests for the changed code? Are existing tests updated?
   - **Documentation**: Do code changes require documentation updates?
   - **Breaking Changes**: Could these changes break existing callers or APIs?

6. **Categorize Findings**
   - **Critical**: Must fix before merge
   - **Suggestion**: Should consider addressing
   - **Nitpick**: Optional improvements

7. **Produce Output**
   - Write to `.agentic-wip/code-review.md` (or output inline if file writing unavailable)
   - Use the template structure below
   - If no issues are found, clearly state "No changes necessary" in the verdict

## Review Mode Details

### Iteration Mode (Light)
**When to use**: Pre-1.0 projects, early development, exploring solutions, draft PRs, work-in-progress code

**Focus on**:
- Is the overall direction and approach sound?
- Are there any major blockers or fundamental issues?
- Does the architecture make sense for the problem?

**Skip or minimize**:
- Minor style issues
- Edge case handling (unless obvious)
- Comprehensive error handling review
- Performance micro-optimizations

**Mindset**: "Is this heading in the right direction?"

### Standard Mode (Medium)
**When to use**: Post-1.0 projects, normal PR review, code ready for merge consideration

**Focus on**:
- Correctness: Does the code do what it's supposed to do?
- Maintainability: Is the code readable and maintainable?
- Style: Does it follow project conventions?
- Error handling: Are errors handled appropriately?
- Testing: Is there adequate test coverage?

**Depth**: Thorough but practical. Flag real issues, not theoretical ones.

**Mindset**: "Would I be comfortable merging this?"

### Critical Mode (Deep)
**When to use**: Particularly complex changes, payment processing, data integrity, core business logic, high-traffic paths, or any code where failures would have significant impact

**Focus on**:
- Edge cases and boundary conditions
- Failure modes and recovery paths
- Data validation and sanitization
- Transaction integrity and consistency
- Race conditions and concurrency issues
- Error propagation and handling completeness

**Approach**:
- Question every assumption
- Trace through execution paths mentally
- Consider "what if this fails?" for each operation
- Look for implicit dependencies

**Mindset**: "What could go wrong, and have we handled it?"

### Security Mode (Deep)
**When to use**: Authentication/authorization code, external input handling, API endpoints, data access layers

**Focus on**:
- Input validation and sanitization
- SQL injection, XSS, command injection vulnerabilities
- Authentication and authorization checks
- Sensitive data handling (logging, storage, transmission)
- CSRF, CORS, and other web security concerns
- Secrets and credential management
- Access control consistency

**Approach**:
- Assume all external input is malicious
- Trace data flow from input to output
- Check for missing authorization at every access point
- Verify secrets are not exposed

**Mindset**: "How could an attacker exploit this?"

## Template for code-review.md

```markdown
# Code Review: [Brief description of what was reviewed]

## Review Summary
- **Mode**: [Iteration / Standard / Critical / Security]
- **Scope**: [Description of files, commits, or PR reviewed]
- **Verdict**: [Approved / Approved with suggestions / Needs revision / No changes necessary]

## Findings

### Critical
[List issues that must be fixed before merge. Include file paths and line numbers where applicable.]
[If none: "None"]

### Suggestions
[List improvements worth considering. Explain the benefit of each suggestion.]
[If none: "None"]

### Nitpicks
[List optional polish items. These are non-blocking observations.]
[If none: "None"]

## Coverage and Documentation
- **Test Gaps**: [List any changed code lacking corresponding tests, or "Adequate coverage"]
- **Documentation Updates Needed**: [List docs that may need updating, or "None identified"]
- **Breaking Changes**: [List any API or interface changes that could affect callers, or "None"]

## Context Reviewed
[List the related files examined for context: tests, callers, imports, documentation]

---
*This review was done in the following style: [Mode]. See the code-review prompt for further details.*
```

## Guidelines

- **Be objective**: Praise what works well and identify what needs improvement. Avoid both excessive criticism and false validation.
- **Be specific**: Include file paths, line numbers, and code snippets when referencing issues. Vague feedback is not actionable.
- **Prioritize correctly**: Not every issue is critical. Use severity levels honestly. A nitpick is not a blocker.
- **"No changes necessary" is valid**: If the code is solid, say so. Do not manufacture issues to justify the review.
- **Stay in scope**: Review what was changed. Avoid scope creep into unrelated code unless it directly impacts the changes.
- **Consider context**: Code decisions often involve tradeoffs. Understand the constraints before criticizing choices.
- **Focus on the code, not the author**: Frame feedback around the code itself, not assumptions about the developer.
- **Provide rationale**: Explain why something is an issue, not just that it is one. Help the author learn.
- **Suggest, don't demand** (for non-critical items): Phrase suggestions as options, not requirements.
- **This is review only**: Do not offer to implement fixes. The review is advisory; implementation is a separate concern.
- Never use emojis or non-ASCII characters in the review output.
