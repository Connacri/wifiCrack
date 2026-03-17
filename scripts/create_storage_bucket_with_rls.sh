#!/usr/bin/env bash
set -euo pipefail

# Creates a Supabase storage bucket (default `product-images`) and attaches
# row-level security policies that tie `storage.objects` operations to the bucket
# owner. The script requires the Supabase CLI to be configured for your project.
#
# Usage:
#   ./scripts/create_storage_bucket_with_rls.sh [bucket-name] [private|public]
#
# Examples:
#   ./scripts/create_storage_bucket_with_rls.sh product-images private
#   ./scripts/create_storage_bucket_with_rls.sh uploads public

BUCKET_NAME="${1:-product-images}"
VISIBILITY="${2:-private}"

if [[ "$VISIBILITY" == "public" ]]; then
  PUBLIC_FLAG="--public"
else
  PUBLIC_FLAG=""
fi

if ! command -v supabase >/dev/null; then
  echo "Supabase CLI not found in PATH. Install it (https://supabase.com/docs/guides/cli) and re-run."
  exit 1
fi

echo "Creating bucket '$BUCKET_NAME' (visibility: $VISIBILITY)..."
if supabase storage bucket create "$BUCKET_NAME" $PUBLIC_FLAG; then
  echo "Bucket '$BUCKET_NAME' created."
else
  echo "Bucket creation command failed (it might already exist). Continuing."
fi

cat <<SQL | supabase db query
-- Note: RLS is already enabled on storage.objects by default or managed by Supabase.

drop policy if exists "bucket_${BUCKET_NAME}_select" on storage.objects;
drop policy if exists "bucket_${BUCKET_NAME}_insert" on storage.objects;
drop policy if exists "bucket_${BUCKET_NAME}_update" on storage.objects;
drop policy if exists "bucket_${BUCKET_NAME}_delete" on storage.objects;

create policy "bucket_${BUCKET_NAME}_select" on storage.objects
  for select
  using (
    bucket_id = '${BUCKET_NAME}' and (
      auth.uid() = owner or auth.role() = 'service_role'
    )
  );

create policy "bucket_${BUCKET_NAME}_insert" on storage.objects
  for insert
  with check (
    bucket_id = '${BUCKET_NAME}' and auth.uid() = owner
  );

create policy "bucket_${BUCKET_NAME}_update" on storage.objects
  for update
  using (
    bucket_id = '${BUCKET_NAME}' and auth.uid() = owner
  );

create policy "bucket_${BUCKET_NAME}_delete" on storage.objects
  for delete
  using (
    bucket_id = '${BUCKET_NAME}' and auth.uid() = owner
  );
SQL

echo "RLS policies defined for bucket '$BUCKET_NAME'."
