-- Run in Supabase SQL editor. Keep the paid-products bucket PRIVATE.
create extension if not exists pgcrypto;
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(),
 razorpay_order_id text unique not null,
 razorpay_payment_id text unique,
 email text not null,
 product_slug text not null,
 amount integer not null check (amount > 0),
 currency text not null default 'INR',
 status text not null default 'created' check (status in ('created','paid','failed','refunded')),
 paid_at timestamptz,
 created_at timestamptz not null default now()
);
create table if not exists public.products (
 slug text primary key, title text not null, description text not null default '', price integer not null check(price > 0),
 pdf_storage_path text, cover_storage_path text, active boolean not null default true, updated_at timestamptz not null default now()
);
create table if not exists public.reviews (
 id uuid primary key default gen_random_uuid(), product_slug text references public.products(slug), display_name text not null,
 body text not null, rating integer not null check(rating between 1 and 5), approved boolean not null default false,
 featured boolean not null default false, order_id uuid references public.orders(id), created_at timestamptz not null default now()
);
create table if not exists public.coupons (
 code text primary key, discount_percent integer check(discount_percent between 1 and 100), active boolean not null default true,
 expires_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.site_settings (
 key text primary key, value jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now()
);
-- Server uses service role only. Do not expose service role key in browser code.
alter table public.orders enable row level security;
alter table public.products enable row level security;
alter table public.reviews enable row level security;
alter table public.coupons enable row level security;
alter table public.site_settings enable row level security;
-- No public policies are intentionally added. Add narrowly scoped policies only after implementing Supabase Auth roles.
-- Storage: create a PRIVATE bucket named paid-products in Supabase Storage; grant access only through server-generated signed URLs.
