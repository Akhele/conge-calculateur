# Installation et Démarrage

## ✅ Prérequis

Votre environnement Flutter est prêt :
- ✓ Flutter SDK 3.32.8 installé
- ✓ Android Studio configuré
- ✓ VS Code avec extensions Flutter
- ✓ Chrome pour le développement web

## 🚀 Démarrage Rapide

### 1. Vérifier l'installation

Les dépendances sont déjà installées. Pour vérifier :

```bash
cd /Users/macbook/Desktop/flutterProjects/conge-calculateur
flutter pub get
```

### 2. Lancer l'application

#### Option A : Sur un émulateur Android
```bash
flutter run
```

#### Option B : Sur Chrome (Web)
```bash
flutter run -d chrome
```

#### Option C : Sur un appareil physique
1. Connectez votre téléphone via USB
2. Activez le mode développeur sur votre téléphone
3. Exécutez :
```bash
flutter devices  # Pour voir les appareils disponibles
flutter run      # Pour lancer sur l'appareil connecté
```

### 3. Compiler l'application

#### Pour Android (APK)
```bash
flutter build apk --release
```
Le fichier APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`

#### Pour Android (App Bundle - Google Play)
```bash
flutter build appbundle --release
```

#### Pour iOS (nécessite un Mac avec Xcode)
```bash
flutter build ios --release
```

## 🧪 Tests

### Exécuter les tests
```bash
flutter test
```

### Analyse du code
```bash
flutter analyze
```

## 📱 Structure du Projet

```
conge-calculateur/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── models/                      # Modèles de données
│   │   ├── holiday.dart
│   │   └── vacation_calculation.dart
│   ├── screens/                     # Écrans de l'application
│   │   ├── home_screen.dart
│   │   ├── calculator_screen.dart
│   │   ├── result_screen.dart
│   │   ├── history_screen.dart
│   │   └── holidays_screen.dart
│   └── services/                    # Logique métier
│       ├── holiday_service.dart
│       ├── vacation_calculator.dart
│       └── vacation_provider.dart
├── test/                            # Tests unitaires
├── pubspec.yaml                     # Dépendances
├── README.md                        # Documentation technique
├── GUIDE_UTILISATION.md            # Guide utilisateur
└── INSTALLATION.md                 # Ce fichier
```

## 🔧 Configuration Optionnelle

### API des Jours Fériés (Optionnel)

L'application fonctionne avec des données intégrées pour 2024-2025. Pour une intégration API :

1. Obtenez une clé API gratuite sur [Calendarific](https://calendarific.com/)
2. Ouvrez `lib/services/holiday_service.dart`
3. Remplacez `YOUR_API_KEY_HERE` par votre clé :

```dart
static const String apiKey = 'votre_clé_api';
```

### Personnalisation

#### Changer le nombre de jours annuels
Éditez `lib/services/vacation_provider.dart` :
```dart
final int _totalAnnualDays = 22; // Changez cette valeur
```

#### Modifier les couleurs
Éditez `lib/main.dart` :
```dart
seedColor: const Color(0xFF1B5E20), // Vert marocain
```

## 📦 Dépendances Principales

- **flutter** : Framework de développement
- **provider** : Gestion d'état
- **http** : Appels API
- **intl** : Formatage des dates
- **shared_preferences** : Stockage local

## 🐛 Résolution de Problèmes

### Erreur : "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Erreur : "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Erreur : "Android licenses not accepted"
```bash
flutter doctor --android-licenses
```

### L'application ne se lance pas
1. Vérifiez qu'un appareil est connecté : `flutter devices`
2. Nettoyez le cache : `flutter clean`
3. Réinstallez les dépendances : `flutter pub get`
4. Relancez : `flutter run`

## 📊 Performances

### Mode Debug vs Release

- **Debug** : Pour le développement, plus lent
  ```bash
  flutter run
  ```

- **Release** : Pour la production, optimisé
  ```bash
  flutter run --release
  ```

### Taille de l'APK

L'APK en mode release fait environ 15-20 MB.

Pour réduire la taille :
```bash
flutter build apk --split-per-abi --release
```

## 🔐 Sécurité

### Données Locales
- Les données sont stockées localement avec `shared_preferences`
- Aucune donnée n'est envoyée à des serveurs externes
- Les données sont perdues lors de la désinstallation

### Permissions Requises
- **Internet** : Pour récupérer les jours fériés (optionnel)
- Aucune autre permission nécessaire

## 📱 Compatibilité

### Android
- Version minimale : Android 5.0 (API 21)
- Version cible : Android 14 (API 34)

### iOS
- Version minimale : iOS 12.0
- Testé jusqu'à iOS 17

### Web
- Chrome, Firefox, Safari, Edge
- Responsive design

## 🔄 Mises à Jour

Pour mettre à jour les dépendances :
```bash
flutter pub upgrade
```

Pour mettre à jour Flutter :
```bash
flutter upgrade
```

## 📞 Support Technique

### Logs de Débogage
```bash
flutter run --verbose
```

### Informations Système
```bash
flutter doctor -v
```

### Nettoyer le Projet
```bash
flutter clean
flutter pub get
```

## 🎯 Prochaines Étapes

1. ✅ Installation complète
2. ✅ Tests passés avec succès
3. ✅ Analyse du code sans erreurs
4. 📱 Prêt à être lancé !

Pour démarrer l'application :
```bash
flutter run
```

---

**Bon développement ! 🚀**

