# CLAUDE.md

Instructions for the coding agent (Claude Code) working in this repository. The private production repository has the same file with the client's details; this is the sanitized version. It is kept short on purpose: what the agent cannot infer from the code, and the mistakes that already cost time once.

## What this is

E-commerce plus a production ERP for a small handmade fashion brand ("Ateliê Exemplo" in this demo). One person runs the whole admin panel: products and stock, raw materials and recipes, production orders, retail and wholesale orders, invoices.

- Storefront: `app/(store)/` — public catalog, cart, checkout, customer account
- Admin: `app/admin/` — single operator, simple and functional, not corporate
- Affiliate portal: `app/afiliada/`
- Webhooks: `app/api/webhooks/{payment,shipping,nfe}`
- Server Actions: `lib/actions/` · server-only modules: `lib/server/` · integrations: `lib/integrations/`, `lib/shipping/`

Domain terms stay in Portuguese in the code (glossary in the README). Do not translate identifiers.

## Commands

```bash
npm run dev          # local app
npm run lint         # ESLint (next lint)
npm run typecheck    # tsc --noEmit
npm test             # Vitest unit tests (lib/**/*.test.ts)
npm run test:db      # SQL tests: throwaway Postgres + all migrations + seed
npm run test:e2e     # Playwright, needs a running app and an admin user
```

Before saying a change is done: `npm run lint`, `npm run typecheck`, `npm test`, and `npm run test:db` when SQL changed.

## Rules that are not visible in the code

**Stock**
- `product_variants.stock_quantity` is the single source of truth for finished goods. It only moves through SQL functions (`decrement_stock`, `increment_stock`, `complete_production_order`, `revert_production_order`), never through an `update` from the app. Each writes a `stock_adjustments` row.
- Stock never goes below zero. Stock is decremented after payment is confirmed, never when an item is added to the cart.
- `complete_production_order` and `revert_production_order` are an exact pair. Changing one means changing the other and the tests in `supabase/tests/production-orders.test.sql`.

**Recipes and colors**
- The bill of materials belongs to the product, not to the variant. Cut items store only category + piece; the color comes from `variant_cut_colors`, one row per cut piece of the recipe (not one per category).
- `resolve_variant_bom(variant_id)` is the only way to read a variant's material list. `resolved = false` means the material does not exist in that color yet: a registration gap, which blocks the production order.
- The placeholder color `Indefinida` exists only for legacy data. Never offer it for a new variant.

**Orders**
- `order_items.unit_price` and the `orders.buyer_*` fields are snapshots taken at purchase time and never change. Read `buyer_* ?? customer.*`, never the customer join alone: the customer record is updated on every checkout.
- Any failure in invoice or label creation stores its reason in `nfe_error` / `shipping_error`. An error status without a message is a bug.
- `fulfillPaidOrder` is the only post-payment path. Its first statement is the conditional update that makes it idempotent; keep every later step in its own try/catch.

**Fiscal (NF-e via Focus NFe)**
- The payload uses flat fields: `cnpj_emitente`, `uf_destinatario`, `icms_situacao_tributaria`. There is no `emitente` or `destinatario` object. Sending `emitente: { cnpj }` makes the API answer HTTP 403 "CNPJ do emitente não autorizado", a permission message for a missing field. Check field names in the Focus NFe docs before adding one.
- CFOP comes from the fiscal-address state versus the buyer's state (5102 in-state, 6102 interstate), never from the shipping origin.
- `getEmitente()` fails closed: no complete fiscal address, no invoice. `getShippingOrigin()` degrades to the legacy env vars. Both live in `lib/server/store-identity.ts`, the only place that reads store addresses.
- NCM codes are the accountant's decision. Do not invent one to unblock a test.

**Security**
- Every admin Server Action starts with `requireAdmin()`. Prices are always read on the server; never trust a price sent by the browser.
- Webhooks are trusted only after signature (Mercado Pago, HMAC with `timingSafeEqual`) or token validation (Melhor Envio, Focus NFe).
- Never hardcode keys. Read env vars with `readEnv` from `lib/env.ts`: the Vercel field keeps an inline `# comment` as part of the value, dotenv does not.

**Admin HTML**
- Interactive elements in the admin get stable `id` and `data-testid` attributes (`id="btn-novo-pedido"`, never a generated id). The panel is also driven by browser automation and by the Playwright tests.
- No action that depends on an animation finishing to be clickable. Success and error messages are text, not only icons.

## Database

- Every schema change is a new numbered file in `supabase/migrations/`. Never edit an applied migration.
- A migration must also apply to an empty database: CI rebuilds the schema from zero on every PR. Guard references to objects that a migration does not create.
- New tables need explicit `GRANT`s for `service_role` (and `authenticated`/`anon` where RLS allows), or Supabase answers "permission denied" even for the service role.
- `CREATE OR REPLACE FUNCTION` drops the function's grants; re-grant in the same migration.
- New stock-moving logic gets a test in `supabase/tests/`.

## Working agreement

- One change per branch, merged by pull request with a description and green CI.
- Do not add a dependency without asking. If one seems missing, name it and stop.
- Do not change design, data model or data flow beyond what was asked; say what else you noticed at the end.
- Comments explain why, not what. Match the language and density of the file you are editing.
- Report results as they are: if a test fails or a step was skipped, say so.
