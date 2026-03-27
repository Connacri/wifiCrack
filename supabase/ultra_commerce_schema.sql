-- ultra-complete commerce + logistics schema for Supabase (PostgreSQL)
-- Drop old tables and enums to start from scratch.
-- Run this in the Supabase SQL editor or via supabase migrations.

drop table if exists public.return_items cascade;
drop table if exists public.returns cascade;
drop table if exists public.delivery_attempts cascade;
drop table if exists public.shipment_events cascade;
drop table if exists public.shipment_items cascade;
drop table if exists public.shipment_packages cascade;
drop table if exists public.shipments cascade;
drop table if exists public.refunds cascade;
drop table if exists public.payments cascade;
drop table if exists public.order_status_transitions cascade;
drop table if exists public.shipment_status_transitions cascade;
drop table if exists public.return_status_transitions cascade;
drop table if exists public.order_events cascade;
drop table if exists public.order_items cascade;
drop table if exists public.orders cascade;
drop table if exists public.products cascade;
drop table if exists public.carriers cascade;
drop table if exists public.addresses cascade;
drop table if exists public.org_members cascade;
drop table if exists public.organizations cascade;
drop table if exists public.user_fcm_tokens cascade;
drop table if exists public.user_ads cascade;
drop table if exists public.user_activity cascade;
drop table if exists public.admin_settings cascade;
drop table if exists public.caroussel cascade;
drop table if exists public.contacts cascade;
drop table if exists public.p2p_signaling cascade;
drop table if exists public.webrtc_signals cascade;
drop table if exists public.wifi_networks cascade;
drop table if exists public.users cascade;

drop type if exists public.app_role cascade;
drop type if exists public.shipment_status cascade;
drop type if exists public.return_status cascade;
drop type if exists public.refund_status cascade;
drop type if exists public.delivery_attempt_status cascade;

create extension if not exists "uuid-ossp";
create extension if not exists pgcrypto;

create type public.app_role as enum (
  'buyer',
  'wholesaler_admin',
  'wholesaler_ops',
  'warehouse_picker',
  'warehouse_packer',
  'carrier_dispatch',
  'courier',
  'support',
  'admin'
);

create type public.shipment_status as enum (
  'label_created',
  'picked_up',
  'in_transit',
  'arrived_at_hub',
  'customs_clearance',
  'out_for_delivery',
  'delivered',
  'delivery_failed',
  'exception',
  'lost',
  'damaged',
  'return_to_sender'
);

create type public.return_status as enum (
  'requested',
  'authorized',
  'label_issued',
  'in_transit',
  'received',
  'rejected',
  'refund_pending',
  'refunded',
  'closed'
);

create type public.refund_status as enum (
  'pending',
  'processing',
  'succeeded',
  'failed'
);

create type public.delivery_attempt_status as enum (
  'success',
  'failed',
  'rescheduled'
);

create table public.users (
  device_id text primary key,
  pseudo text unique,
  model text,
  last_seen timestamptz default now(),
  coins bigint default 0
);

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  org_type text not null check (org_type in ('wholesaler','carrier','warehouse','marketplace')),
  created_at timestamptz not null default now()
);

create table public.org_members (
  org_id uuid not null references public.organizations(id) on delete cascade,
  user_id text not null references public.users(device_id) on delete cascade,
  role public.app_role not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (org_id, user_id, role)
);

create table public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id text references public.users(device_id),
  org_id uuid references public.organizations(id),
  label text,
  full_name text,
  phone text,
  line1 text not null,
  line2 text,
  city text,
  state text,
  postal_code text,
  country text not null,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now()
);

create table public.carriers (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  scac text,
  tracking_url_template text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.admin_settings (
  key text primary key,
  value text not null,
  updated_at timestamptz default now()
);

create table public.contacts (
  phone text primary key,
  name text
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sku text unique,
  description text,
  price numeric not null check (price >= 0),
  promo_price numeric check (promo_price is null or promo_price >= 0),
  category text,
  stock integer,
  image_url text,
  is_active boolean not null default true,
  popularity integer not null default 0 check (popularity >= 0),
  metadata jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique,
  buyer_id text not null references public.users(device_id),
  seller_org_id uuid references public.organizations(id),
  currency text not null default 'USD',
  status text not null default 'created',
  payment_status text not null default 'pending',
  subtotal numeric not null default 0 check (subtotal >= 0),
  shipping_total numeric not null default 0 check (shipping_total >= 0),
  tax_total numeric not null default 0 check (tax_total >= 0),
  discount_total numeric not null default 0 check (discount_total >= 0),
  grand_total numeric not null default 0 check (grand_total >= 0),
  shipping_address_id uuid references public.addresses(id),
  billing_address_id uuid references public.addresses(id),
  note text,
  items jsonb, -- Keep jsonb items for app compatibility
  placed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id),
  sku text,
  name text not null,
  description text,
  quantity integer not null check (quantity > 0),
  unit_price numeric not null check (unit_price >= 0),
  subtotal numeric not null check (subtotal >= 0),
  tax_total numeric not null default 0 check (tax_total >= 0),
  discount_total numeric not null default 0 check (discount_total >= 0),
  weight_kg numeric,
  metadata jsonb,
  created_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  provider text not null,
  provider_ref text,
  amount numeric not null check (amount >= 0),
  currency text not null,
  status text not null default 'pending',
  authorized_at timestamptz,
  captured_at timestamptz,
  failed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.refunds (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  payment_id uuid references public.payments(id),
  amount numeric not null check (amount >= 0),
  status public.refund_status not null default 'pending',
  reason text,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

-- ... rest of tables ...

create table public.order_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  status text not null,
  note text,
  actor_user_id text references public.users(device_id),
  actor_role public.app_role,
  source text not null default 'system',
  created_at timestamptz not null default now()
);

create table public.order_status_transitions (
  from_status text not null,
  to_status text not null,
  allowed_roles public.app_role[] not null,
  primary key (from_status, to_status)
);

create table public.shipment_status_transitions (
  from_status public.shipment_status not null,
  to_status public.shipment_status not null,
  allowed_roles public.app_role[] not null,
  primary key (from_status, to_status)
);

create table public.return_status_transitions (
  from_status public.return_status not null,
  to_status public.return_status not null,
  allowed_roles public.app_role[] not null,
  primary key (from_status, to_status)
);

-- ...

-- Indexes
create index on public.orders (buyer_id);
create index on public.orders (status);
create index on public.orders (seller_org_id);
create index on public.shipments (order_id);
create index on public.shipment_events (shipment_id, occurred_at desc);
create index on public.returns (order_id);

-- (Removed fixed transitions as they are managed in-app now)

