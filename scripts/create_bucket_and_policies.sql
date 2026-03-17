
-- Create the bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', false)
ON CONFLICT (id) DO NOTHING;

-- Create/refresh storage bucket policies. Run this via SQL Editor in service_role context
-- Note: RLS is already enabled on storage.objects by default or managed by Supabase.

drop policy if exists "bucket_product-images_select" on storage.objects;
drop policy if exists "bucket_product-images_insert" on storage.objects;
drop policy if exists "bucket_product-images_update" on storage.objects;
drop policy if exists "bucket_product-images_delete" on storage.objects;

create policy "bucket_product-images_select" on storage.objects
  for select
  using (
    bucket_id = 'product-images' and (
      auth.uid() = owner or auth.role() = 'service_role'
    )
  );

create policy "bucket_product-images_insert" on storage.objects
  for insert
  with check (
    bucket_id = 'product-images' and auth.uid() = owner
  );

create policy "bucket_product-images_update" on storage.objects
  for update
  using (
    bucket_id = 'product-images' and auth.uid() = owner
  );

create policy "bucket_product-images_delete" on storage.objects
  for delete
  using (
    bucket_id = 'product-images' and auth.uid() = owner
  );

