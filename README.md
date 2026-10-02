# stevensinatra.id

This is my website codebase.

## Local setup

Use Node.js 24 and pnpm 12.8.1. Both versions are pinned in the repo.

```sh
pnpm install --frozen-lockfile
pnpm run dev
```

Before opening a PR, run `pnpm lint`, `pnpm format:check`, `pnpm build`, and
`pnpm audit --audit-level high`.
