# CLAUDE.md

## Coding Style
- Prefer readable code over clever code
- Add comments for complex logic
- Keep functions small
- Avoid unnecessary dependencies

## Environment
- Prefer local-first workflows
- Avoid cloud APIs unless requested

## Testing
- Always add tests when modifying logic
- Explain how to run tests

## Security
- Never expose secrets
- Use least privilege
- Prefer read-only containers when possible

## Directory & File Structure
- Follow a flat structure when possible; avoid deep nesting
- Group related files together (e.g., all game assets in `assets/`)
- Use consistent naming: `kebab-case` for files, `PascalCase` for classes
- Place public entry points at the root level (e.g., `index.js`, `main.py`)
- Keep configuration separate from code (use `config/` or `.env` files)
- Document the directory structure in a `README.md` if it's non-trivial

