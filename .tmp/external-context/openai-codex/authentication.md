---
source: Context7 API
library: OpenAI Codex / Codex ACP
package: openai-codex
topic: authentication and session
fetched: 2026-04-12T00:00:00Z
official_docs: https://developers.openai.com/codex/auth
---

## Relevant docs

### Authentication

- `codex login` authenticates the CLI with either a ChatGPT account or an API key.
- Without flags, it starts a browser-based OAuth flow.
- `codex login status` checks for existing credentials.

```bash
codex login
codex login --api-key YOUR_API_KEY
codex login status
```

### Environment auth for automation

```bash
CODEX_API_KEY=<api-key> codex exec --json "triage open bug reports"
```

### Codex ACP auth support

- The Codex ACP adapter supports ChatGPT auth and API-key auth.
- It can read `CODEX_API_KEY` or `OPENAI_API_KEY` from the environment.

### Likely failure modes

- No existing Codex login/session in the CLI home directory.
- `OPENAI_API_KEY`/`CODEX_API_KEY` missing when the adapter falls back to key auth.
- Browser OAuth blocked in headless or remote environments.
