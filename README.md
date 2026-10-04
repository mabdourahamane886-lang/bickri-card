# Bickri Card

Application mobile Bickri Card — portefeuille, KYC et gestion de cartes.

## Architecture
- Flutter mobile
- Supabase Auth + PostgreSQL + RLS
- Supabase Edge Function: bickri-card-api
- Intégration future avec un émetteur/processor autorisé pour la carte Visa

Important: ce dépôt ne génère pas de PAN/CVV réel et ne remplace pas un émetteur de cartes agréé.

## Configuration
Copier .env.example vers la configuration locale. Ne jamais committer de clé secrète/service_role.

## Fonctionnalités prévues
- Connexion / inscription
- Profil et KYC
- Tableau de bord et solde
- Demande de carte virtuelle/physique
- Historique des transactions
- Blocage/déblocage de carte
- Rechargement et transferts
- Intégration issuer/processor
