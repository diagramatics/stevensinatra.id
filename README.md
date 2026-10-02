# stevensinatra.id

This is my website codebase.

## Local setup

Use Node.js 24 and Corepack. The project pins pnpm 12 in `package.json`.

```sh
corepack pnpm install --frozen-lockfile
corepack pnpm run dev
```

Before opening a PR, run `corepack pnpm lint`, `corepack pnpm format:check`,
`corepack pnpm build`, and `corepack pnpm audit --audit-level high`.
