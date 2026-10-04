# Bickri Card — KYC Admin

The KYC system now uses a private Supabase Storage bucket and RLS.

## Admin authorization

An administrator is represented by a row in `public.bickri_admin_users`:

```sql
insert into public.bickri_admin_users (user_id)
values ('ADMIN_AUTH_USER_UUID');
```

Never put an admin/service key in the Flutter app.

## Workflow

1. User signs in.
2. User uploads identity document, proof of address and selfie.
3. Files are stored under `bickri-kyc/<user_id>/...`.
4. Metadata is stored in `bickri_kyc_documents` with status `pending`.
5. Authorized admin reviews the dossier.
6. Admin changes document/profile status to `verified` or `rejected`.
7. Only a verified KYC profile can request a card.

## Production KYC provider

Automated identity verification still requires a licensed KYC/identity-verification provider. The application should store only the provider reference and decision, not raw verification secrets.

The app does not manufacture a Visa PAN/CVV. Card issuance must be performed by an authorized issuer/program partner.
