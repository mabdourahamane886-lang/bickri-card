-- Bickri Card: secure KYC storage
-- Apply through Supabase migrations. KYC files remain private.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'bickri-kyc',
  'bickri-kyc',
  false,
  6291456,
  array['image/jpeg','image/png','image/webp','application/pdf']
)
on conflict (id) do update
set public=false, file_size_limit=6291456, allowed_mime_types=excluded.allowed_mime_types;

drop policy if exists "Bickri KYC upload own folder" on storage.objects;
drop policy if exists "Bickri KYC read own files" on storage.objects;
drop policy if exists "Bickri KYC delete own files" on storage.objects;

create policy "Bickri KYC upload own folder"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'bickri-kyc'
  and (storage.foldername(name))[1] = (select auth.uid()::text)
);

create policy "Bickri KYC read own files"
on storage.objects for select to authenticated
using (
  bucket_id = 'bickri-kyc'
  and owner_id = (select auth.uid()::text)
);

create policy "Bickri KYC delete own files"
on storage.objects for delete to authenticated
using (
  bucket_id = 'bickri-kyc'
  and owner_id = (select auth.uid()::text)
);
