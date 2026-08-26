# Project Agents and Instructions

## Workspace Layout

- Project root: `/Users/nicorithner/coding_repos/learning/RoR/`
- Rails app lives in: `/Users/nicorithner/coding_repos/learning/RoR/vault/`
- Lesson files live in: `/Users/nicorithner/coding_repos/learning/RoR/lessons/`
- VSCode workspace root: `vault/` (opened from inside `vault/`, not the parent)
- Rails commands (`bin/rails`, `bundle install`, `bin/rails spec`) must run from `vault/`
- Always use absolute paths when reading/writing files: `/Users/nicorithner/coding_repos/learning/RoR/vault/...`
- Do not look for `.vscode/`, `Gemfile`, `config/`, or `app/` in the parent directory — they are in `vault/`

## Lesson Writer

When writing or updating lessons in `lessons/lesson_<number>.md`, follow these rules:

- Structure: **Explain** → **Setup** → **Practice**
- **Explain**: High-level concept review, not a verbatim restatement of the task
- **Setup**: Mechanical steps only (generators, migrations, installs). No implementation logic
- **Practice**: Coding tasks with requirements and hints. **Never provide complete implementation code**
- Code snippets in lessons are illustrative examples only — the user must write the actual code
- If you catch yourself writing more than a few lines of implementation in a lesson, stop
- The user learns by writing code from requirements, not by transcribing examples

## Review

After the user completes a task:
1. Read their actual code
2. Give specific, technical feedback
3. Point out issues and explain why they matter
4. Provide corrected code only in review, never in the lesson file itself
