# LaunchKit AI — setup guide

This repository contains an MVP codebase, not a deployed or revenue-ready business. It is intentionally isolated in this folder and branch.

## Files
- `index.html`: public request form
- `admin.html`: private operator dashboard
- `supabase/schema.sql`: orders table and row-level security
- `supabase/functions/generate-pack/index.ts`: secured AI generation endpoint

## 1. Create and configure Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. In Project Settings → API, copy the Project URL and anon/public key.
4. Replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` in both HTML files.
5. In Authentication → Users, create the operator account.
6. Grant that user the server-managed app metadata claim `{"role":"admin"}` using the Supabase dashboard or a trusted server-side admin process. Do not put admin role in user-editable metadata.

## 2. Deploy the Edge Function
Install and authenticate the Supabase CLI, link the project, then set secrets:
```sh
supabase secrets set OPENAI_API_KEY=your_provider_key
supabase functions deploy generate-pack
```
Supabase provides SUPABASE_URL, SUPABASE_ANON_KEY and SUPABASE_SERVICE_ROLE_KEY to deployed functions. Never put the service-role key or AI key in either HTML file or GitHub.

The function refuses to generate a pack unless the operator is authenticated as admin and the order payment status is marked verified. Verify payment manually using trusted transaction records, not screenshots alone.

## 3. Host the static site
Publish this folder using a static host (for example, a separate GitHub Pages site or another static hosting provider). Configure the host's published directory to `launchkit-ai`. The admin page should not be linked publicly; access is protected by Supabase authentication and database policies.

## 4. Before accepting real customers
- Replace the example contact email in index.html with a monitored business email.
- Set a real price, delivery time, refund policy, privacy notice and terms.
- Test a complete order from another browser/device.
- Test admin login, payment verification, AI generation, review, and delivery.
- Add rate limiting / abuse protection and a data retention policy.
- Confirm provider, hosting and payment availability in the countries you intend to serve.

## Current limitations
- No live website deployment has been performed by this repository commit.
- No Supabase project is connected until you add its URL and public key.
- No AI key is configured; generation will fail until the Edge Function is deployed with OPENAI_API_KEY.
- There is no automatic payment gateway or crypto payout. Payment confirmation and customer delivery are manual.
- The sample contact email is a placeholder and must be replaced.
