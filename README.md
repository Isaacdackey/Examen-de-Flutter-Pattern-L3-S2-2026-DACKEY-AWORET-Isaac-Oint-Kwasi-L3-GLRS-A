# BadWallet Mobile

BadWallet Mobile est une application mobile développée avec Flutter permettant de gérer un portefeuille électronique depuis un smartphone. Elle communique avec la BadWallet API et le Payment Service afin d'offrir les principales fonctionnalités de gestion financière.

## Description

L'application permet aux utilisateurs de :

- S'authentifier
- Consulter leur solde en temps réel
- Effectuer des transferts d'argent
- Consulter et payer des factures
- Visualiser l'historique des transactions

## Fonctionnalités

- Authentification (connexion et inscription)
- Tableau de bord avec affichage du solde
- Transfert d'argent
- Paiement de factures (ISM, WOYAFAL et RAPIDO)
- Historique des transactions
- Stockage sécurisé des données utilisateur
- Interface Flutter moderne et responsive

## Technologies utilisées

| Technologie | Version | Utilisation |
|-------------|---------|-------------|
| Flutter | 3.x | Framework mobile |
| Dart | 3.x | Langage de programmation |
| Provider | 6.0.5 | Gestion d'état |
| HTTP | 1.1.0 | Communication avec les API REST |
| flutter_secure_storage | 9.0.0 | Stockage sécurisé |
| flutter_spinkit | 5.2.0 | Indicateurs de chargement |
| fluttertoast | 8.2.14 | Notifications utilisateur |
| intl | 0.18.1 | Formatage des dates et montants |

## Architecture du projet

```text
lib/
├── core/
│   ├── constants/
│   ├── models/
│   ├── services/
│   └── utils/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── transfers/
│   ├── bills/
│   └── history/
└── main.dart
```

## Installation

### Prérequis

- Flutter SDK 3.x
- Dart SDK
- Android Studio ou Visual Studio Code
- Android SDK
- Un émulateur Android ou un appareil physique

### Cloner le projet

```bash
git clone https://github.com/Isaacdackey/Examen-de-Flutter-Pattern-L3-S2-2026-DACKEY-AWORET-Isaac-Oint-Kwasi-L3-GLRS-A.git
cd Examen-de-Flutter-Pattern-L3-S2-2026-DACKEY-AWORET-Isaac-Oint-Kwasi-L3-GLRS-A
```

### Installer les dépendances

```bash
flutter pub get
```

### Vérifier l'environnement Flutter

```bash
flutter doctor
```

### Lancer l'application

```bash
flutter run
```

## Comptes de démonstration

| Rôle | Téléphone | Mot de passe | Solde |
|------|-----------|--------------|--------|
| Client | +221770000001 | password123 | 150 000 FCFA |
| Client | +221770000004 | password123 | 50 000 FCFA |
| Client | +221770000005 | password123 | 320 000 FCFA |
| Agent | +221770000002 | password123 | 80 000 FCFA |
| Agent | +221770000003 | password123 | 200 000 FCFA |

## API consommées

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/api/auth/login` | POST | Authentification |
| `/api/auth/register` | POST | Création d'un compte |
| `/api/wallets/{phone}/balance` | GET | Consultation du solde |
| `/api/wallets/transfer` | POST | Transfert d'argent |
| `/api/wallets/{phone}/transactions` | GET | Historique des transactions |
| `/api/external/factures/{code}/current` | GET | Consultation des factures |
| `/api/wallets/pay-factures` | POST | Paiement des factures |

## Compilation de l'application

Nettoyer le projet :

```bash
flutter clean
```

Télécharger les dépendances :

```bash
flutter pub get
```

Construire l'APK en mode Release :

```bash
flutter build apk --release
```

APK générée :

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Résultat de compilation

La compilation de l'application a été effectuée avec succès.

| Élément | Valeur |
|---------|--------|
| Type de build | Release |
| Statut | Réussi |
| Taille de l'APK | 49.9 MB |
| Emplacement | `build/app/outputs/flutter-apk/app-release.apk` |

Flutter peut signaler que certaines dépendances possèdent des versions plus récentes compatibles avec des contraintes différentes. Cela n'empêche pas la génération correcte de l'application.

## Dépendances principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
  flutter_spinkit: ^5.2.0
  fluttertoast: ^8.2.14
  intl: ^0.18.1
```

## Structure fonctionnelle

- Authentification des utilisateurs
- Consultation du portefeuille
- Consultation du solde
- Transfert d'argent entre utilisateurs
- Consultation de l'historique des transactions
- Paiement des factures
- Gestion sécurisée de la session utilisateur

## Auteur

**DACKEY AWORET Isaac Oint Kwasi**

Licence 3 Génie Logiciel et Réseaux (GLRS-A)

Examen Flutter - Semestre 2 - 2026

## Contact

- Email : douvewane85@gmail.com
- GitHub : https://github.com/Isaacdackey

## Licence

Ce projet a été réalisé dans le cadre de l'examen de Flutter (L3 GLRS - 2026).

Dernière mise à jour : Juin 2026.
