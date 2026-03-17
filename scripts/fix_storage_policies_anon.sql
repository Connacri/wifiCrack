
-- Fix Storage Policies for Anonymous Access (since we use device_id instead of Supabase Auth)

-- 1. Ensure bucket is public for easy read access if desired, 
-- or keep it private but allow anon to select.
UPDATE storage.buckets SET public = false WHERE id = 'product-images';

-- 2. Clean up old policies
drop policy if exists "bucket_product-images_select" on storage.objects;
drop policy if exists "bucket_product-images_insert" on storage.objects;
drop policy if exists "bucket_product-images_update" on storage.objects;
drop policy if exists "bucket_product-images_delete" on storage.objects;

-- 3. Allow anyone (anon) to see images in this bucket
create policy "bucket_product-images_select" on storage.objects for select
  using ( bucket_id = 'product-images' );

-- 4. Allow anyone (anon) to upload images to this bucket
-- Note: In a production app with real users, you'd want more restriction,
-- but since we don't use Supabase Auth, we allow 'anon' role.
create policy "bucket_product-images_insert" on storage.objects for insert
  with check ( 
    bucket_id = 'product-images' 
    and (auth.role() = 'anon' or auth.role() = 'authenticated' or auth.role() = 'service_role')
  );

-- 5. Allow anyone to update/delete (Optional: you might want to restrict this later)
create policy "bucket_product-images_update" on storage.objects for update
  using ( bucket_id = 'product-images' );

create policy "bucket_product-images_delete" on storage.objects for delete
  using ( bucket_id = 'product-images' );
