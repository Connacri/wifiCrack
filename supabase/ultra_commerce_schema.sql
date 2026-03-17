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
drop table if exists public.carriers cascade;
drop table if exists public.addresses cascade;
drop table if exists public.org_members cascade;
drop table if exists public.organizations cascade;
drop table if exists public.user_fcm_tokens cascade;
drop table if exists public.user_ads cascade;
drop table if exists public.user_activity cascade;
drop table if exists public.cctv_orders cascade;
drop table if exists public.cctv_products cascade;
drop table if exists public.admin_settings cascade;
drop table if exists public.caroussel cascade;
drop table if exists public.contacts cascade;
drop table if exists public.p2p_signaling cascade;
drop table if exists public.webrtc_signals cascade;
drop table if exists public.wifi_networks cascade;
drop table if exists public.users cascade;

drop type if exists public.app_role cascade;
drop type if exists public.order_status cascade;
drop type if exists public.payment_status cascade;
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

create type public.order_status as enum (
  'created',
  'pending_payment',
  'paid',
  'payment_failed',
  'cancel_requested',
  'cancelled',
  'order_confirmed',
  'stock_allocated',
  'backorder',
  'picking',
  'packed',
  'ready_to_ship',
  'partially_shipped',
  'shipped',
  'in_transit',
  'out_for_delivery',
  'partially_delivered',
  'delivered',
  'delivery_failed',
  'exception',
  'return_requested',
  'return_authorized',
  'return_in_transit',
  'return_received',
  'refund_pending',
  'refunded',
  'closed'
);

create type public.payment_status as enum (
  'pending',
  'authorized',
  'captured',
  'failed',
  'voided',
  'partially_refunded',
  'refunded',
  'chargeback'
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

create table public.cctv_orders (
  id uuid default gen_random_uuid() primary key,
  user_id text not null,
  phone text not null,
  address text not null,
  note text,
  total numeric not null check (total >= 0),
  status text not null default 'pending',
  items jsonb not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.cctv_products (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  description text,
  price numeric not null check (price >= 0),
  image_url text,
  category text,
  stock integer,
  is_active boolean not null default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  sku text,
  promo_price numeric,
  popularity integer not null default 0 check (popularity >= 0)
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sku text unique,
  description text,
  price numeric not null check (price >= 0),
  promo_price numeric,
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
  status public.order_status not null default 'created',
  payment_status public.payment_status not null default 'pending',
  subtotal numeric not null default 0 check (subtotal >= 0),
  shipping_total numeric not null default 0 check (shipping_total >= 0),
  tax_total numeric not null default 0 check (tax_total >= 0),
  discount_total numeric not null default 0 check (discount_total >= 0),
  grand_total numeric not null default 0 check (grand_total >= 0),
  shipping_address_id uuid references public.addresses(id),
  billing_address_id uuid references public.addresses(id),
  note text,
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
  status public.payment_status not null default 'pending',
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

create table public.shipments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  carrier_id uuid references public.carriers(id),
  status public.shipment_status not null default 'label_created',
  service_level text,
  tracking_number text unique,
  tracking_url text,
  origin_address_id uuid references public.addresses(id),
  destination_address_id uuid references public.addresses(id),
  shipped_at timestamptz,
  delivered_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.shipment_packages (
  id uuid primary key default gen_random_uuid(),
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  package_no integer not null,
  tracking_number text unique,
  status public.shipment_status not null default 'label_created',
  weight_kg numeric,
  length_cm numeric,
  width_cm numeric,
  height_cm numeric,
  created_at timestamptz not null default now(),
  constraint shipment_packages_uniq unique (shipment_id, package_no)
);

create table public.shipment_items (
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  order_item_id uuid not null references public.order_items(id) on delete cascade,
  quantity integer not null check (quantity > 0),
  created_at timestamptz not null default now(),
  primary key (shipment_id, order_item_id)
);

create table public.shipment_events (
  id uuid primary key default gen_random_uuid(),
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  package_id uuid references public.shipment_packages(id),
  status public.shipment_status not null,
  event_code text,
  description text,
  location_city text,
  location_state text,
  location_country text,
  occurred_at timestamptz not null,
  source text not null default 'system',
  raw_payload jsonb,
  created_at timestamptz not null default now()
);

create table public.delivery_attempts (
  id uuid primary key default gen_random_uuid(),
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  package_id uuid references public.shipment_packages(id),
  attempt_no integer not null,
  status public.delivery_attempt_status not null,
  attempted_at timestamptz not null,
  failure_reason text,
  signed_by text,
  pod_photo_url text,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now(),
  unique (shipment_id, attempt_no)
);

create table public.returns (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  status public.return_status not null default 'requested',
  reason_code text,
  reason_text text,
  requested_by text references public.users(device_id),
  authorized_by text references public.users(device_id),
  carrier_id uuid references public.carriers(id),
  tracking_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.return_items (
  id uuid primary key default gen_random_uuid(),
  return_id uuid not null references public.returns(id) on delete cascade,
  order_item_id uuid not null references public.order_items(id),
  quantity integer not null check (quantity > 0),
  condition text,
  resolution text,
  created_at timestamptz not null default now()
);

create table public.order_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  status public.order_status not null,
  note text,
  actor_user_id text references public.users(device_id),
  actor_role public.app_role,
  source text not null default 'system',
  created_at timestamptz not null default now()
);

create table public.order_status_transitions (
  from_status public.order_status not null,
  to_status public.order_status not null,
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

create table public.user_fcm_tokens (
  device_id text not null references public.users(device_id),
  fcm_token text not null,
  updated_at timestamptz not null default now(),
  primary key (device_id)
);

create table public.user_activity (
  id uuid primary key default gen_random_uuid(),
  latitude double precision,
  longitude double precision,
  contacts_count integer,
  timestamp timestamptz,
  device_id text references public.users(device_id)
);

create table public.user_ads (
  id bigint generated always as identity primary key,
  user_id text references public.users(device_id),
  description text,
  image_url text,
  link text,
  status text default 'pending',
  created_at timestamptz default now()
);

create table public.p2p_signaling (
  id bigint generated always as identity primary key,
  target_id text,
  payload jsonb,
  created_at timestamptz default now(),
  foreign key (target_id) references public.users(device_id)
);

create table public.webrtc_signals (
  id bigint primary key default nextval('webrtc_signals_id_seq'::regclass),
  from_device text not null,
  to_device text not null,
  signal_type text not null check (signal_type in ('offer','answer','iceCandidate','presence','typing')),
  data jsonb not null,
  created_at timestamptz not null default now()
);

create table public.wifi_networks (
  ssid text primary key,
  calculated_key text,
  signal_strength integer,
  last_seen timestamptz,
  last_success boolean
);

create table public.caroussel (
  id bigint generated always as identity primary key,
  text text,
  image_url text,
  link text,
  created_at timestamptz default now()
);

create table public.admin_settings (
  key text primary key,
  value text not null,
  updated_at timestamptz default now()
);

-- Indexes
create index on public.orders (buyer_id);
create index on public.orders (status);
create index on public.orders (seller_org_id);
create index on public.shipments (order_id);
create index on public.shipment_events (shipment_id, occurred_at desc);
create index on public.returns (order_id);

-- Sample transitions (optional, adjust as needed)
insert into public.order_status_transitions (from_status, to_status, allowed_roles) values
  ('created', 'order_confirmed', array['wholesaler_admin', 'wholesaler_ops']),
  ('order_confirmed', 'stock_allocated', array['warehouse_picker', 'warehouse_packer']),
  ('stock_allocated', 'picking', array['warehouse_picker']),
  ('picking', 'packed', array['warehouse_packer']),
  ('packed', 'ready_to_ship', array['warehouse_packer']),
  ('ready_to_ship', 'shipped', array['carrier_dispatch']),
  ('shipped', 'in_transit', array['carrier_dispatch']),
  ('in_transit', 'out_for_delivery', array['carrier_dispatch', 'courier']),
  ('out_for_delivery', 'delivered', array['courier']),
  ('delivered', 'return_requested', array['support']),
  ('return_requested', 'return_authorized', array['support']),
  ('return_authorized', 'return_in_transit', array['support', 'courier']),
  ('return_in_transit', 'return_received', array['support']),
  ('return_received', 'refund_pending', array['support']),
  ('refund_pending', 'refunded', array['support']);

insert into public.shipment_status_transitions (from_status, to_status, allowed_roles) values
  ('label_created', 'picked_up', array['carrier_dispatch']),
  ('picked_up', 'in_transit', array['carrier_dispatch']),
  ('in_transit', 'arrived_at_hub', array['carrier_dispatch']),
  ('arrived_at_hub', 'out_for_delivery', array['carrier_dispatch']),
  ('out_for_delivery', 'delivered', array['courier']),
  ('out_for_delivery', 'delivery_failed', array['courier']),
  ('delivery_failed', 'exception', array['support']),
  ('delivered', 'return_to_sender', array['support']);

insert into public.return_status_transitions (from_status, to_status, allowed_roles) values
  ('requested', 'authorized', array['support']),
  ('authorized', 'label_issued', array['support']),
  ('label_issued', 'in_transit', array['courier']),
  ('in_transit', 'received', array['support']),
  ('received', 'refund_pending', array['support']),
  ('refund_pending', 'refunded', array['support']);
