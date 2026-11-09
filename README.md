# LaunchKit AI

A focused MVP for turning product briefs into reviewed marketing content packs.

## What is in this folder
- `index.html` — customer request form
- `admin.html` — authenticated operator dashboard
- `supabase/schema.sql` — orders database and row-level security
- `supabase/functions/generate-pack/index.ts` — admin-only AI content generation
- `SETUP.md` — configuration and deployment instructions

## Order flow
1. Customer submits a product brief.
2. Request is stored as pending.
3. Operator contacts customer and confirms scope, price and timing.
4. Operator verifies payment in the dashboard.
5. The AI function generates a structured content pack.
6. Operator reviews and manually delivers the approved content.

## Status
**MVP source code committed; not yet deployed or connected to live services.** Supabase project configuration, admin account, AI provider secret, hosting, business contact details, payment process, privacy terms and end-to-end testing are still required.

See [SETUP.md](SETUP.md) before deployment. Never publish service-role keys, AI keys, wallet seed phrases or private keys.


See [setup guide](SETUP.md) before connecting services.
