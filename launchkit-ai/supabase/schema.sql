-- LaunchKit AI MVP schema
-- Run this in the Supabase SQL Editor. Then set app_metadata.role = "admin"
-- for the operator account using the Supabase dashboard (never user_metadata).
create extension if not exists pgcrypto;

create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(),
 created_at timestamptz not null default now(),
 customer_name text not null check (char_length(customer_name) between 1 and 100),
 email text not null check (char_length(email) <= 200),
 channel text not null default 'Instagram',
 product_name text not null check (char_length(product_name) between 1 and 160),
 target_audience text not null check (char_length(target_audience) between 1 and 240),
 product_details text not null check (char_length(product_details) between 1 and 3000),
 language text not null default 'English',
 reference_url text,
 status text not null default 'pending' check (status in ('pending','confirmed','generating','review','delivered','rejected')),
 payment_status text not null default 'unverified' check (payment_status in ('unverified','verified','refunded')),
 generated_content jsonb,
 operator_notes text,
 updated_at timestamptz not null default now()
);

alter table public.orders enable row level security;

-- Public visitors may submit requests, but cannot read or change any order.
drop policy if exists "public can submit orders" on public.orders;
create policy "public can submit orders" on public.orders
 for insert to anon, authenticated
 with check (
  status = 'pending' and payment_status = 'unverified'
  and generated_content is null and operator_notes is null
 );

-- Only an authenticated account with server-managed app_metadata role=admin can access orders.
drop policy if exists "admins can read orders" on public.orders;
create policy "admins can read orders" on public.orders
 for select to authenticated
 using ((auth.jwt()->'app_metadata'->>'role') = 'admin');

drop policy if exists "admins can update orders" on public.orders;
create policy "admins can update orders" on public.orders
 for update to authenticated
 using ((auth.jwt()->'app_metadata'->>'role') = 'admin')
 with check ((auth.jwt()->'app_metadata'->>'role') = 'admin');

create index if not exists orders_created_at_idx on public.orders (created_at desc);
create index if not exists orders_status_idx on public.orders (status);

-- Do not expose service-role keys in the browser. Keep AI provider keys in Edge Function secrets.
