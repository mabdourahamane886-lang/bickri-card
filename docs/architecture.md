# Architecture Bickri Card

Flutter -> Supabase Auth -> Edge Function -> PostgreSQL/RLS -> issuer/processor autorisé.

Le mobile utilise uniquement une clé Supabase publiable. Les opérations sensibles passent par l'Edge Function et les contrôles serveur.

Tables principales:
- bickri_card_profiles
- bickri_card_accounts
- bickri_cards
- bickri_kyc_documents
- bickri_card_transactions
- bickri_card_webhooks

Les données de carte sensibles ne doivent pas être stockées directement dans l'application.
