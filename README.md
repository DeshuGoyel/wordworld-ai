<div align="center">

<img src="web/icons/Icon-192.png" alt="WordWorld Logo" width="100" />

# 🌍 WordWorld AI — Kids Learning Universe

**An AI-powered Flutter educational app for kids aged 2–8**  
*Learn • Play • Grow — Every day, every way*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-DeshuGoyel%2Fwordworld--ai-black?logo=github)](https://github.com/DeshuGoyel/wordworld-ai)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Running Tests](#-running-tests)
- [AI Integration](#-ai-integration)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)

---

## 🎯 Overview

WordWorld AI is a comprehensive, AI-first learning universe designed for young children. It combines the best elements of gamification (like Duolingo) with rich educational content across **12+ subjects** — from Phonics and Reading to Coding, Art, Advanced Math, and Environmental Science.

Every part of the app is designed to be:
- 🎨 **Beautiful** — vibrant, kid-friendly UI with smooth animations
- 🧠 **Adaptive** — AI-driven difficulty that adjusts to each child
- 🏆 **Rewarding** — XP, streaks, star ratings, leaderboards, and confetti
- 💾 **Persistent** — progress is saved across app restarts using Hive
- 🔒 **Safe** — parent lock and child profile management built-in

---

## ✨ Features

### 🏠 Core Experience
| Feature | Description |
|---------|-------------|
| **Multi-Child Profiles** | Create & manage separate learning profiles per child |
| **XP System** | Earn XP for every activity — watch your rank climb from Seedling → Champion |
| **Daily Streaks** | Keep your streak alive! Freeze protection saves you when you miss a day |
| **Hearts System** | Limited hearts per session to encourage focus (Duolingo-style) |
| **Daily Challenges** | A new challenge every day across all subjects |
| **Leaderboard** | See how your child ranks among learners |

### 📚 Learning Modules

| Subject | Modules | Description |
|---------|---------|-------------|
| **🔤 Word World** | Meet · Talk · Draw · Write · Think · Story | Deep-dive into individual words with 6 learning modes each |
| **🔊 Phonics** | CVC · Blends · Digraphs · Long Vowels | Phonics sounds with audio-visual learning |
| **👁️ Sight Words** | Levels 1–3 | Dolch sight word mastery through flashcards |
| **📚 Reading** | Short Stories · Comprehension | AI-read passages with comprehension questions |
| **✍️ Story Writing** | Creative Prompts | AI story starters with kid-friendly prompts |
| **🔢 Math World** | Numbers · Shapes · Addition · Subtraction | Core K-2 mathematics |
| **💰 Advanced Math** | Multiplication · Fractions · Money · Time · Geometry | Ages 6–8 advanced topics |
| **🌿 EVS World** | Plants · Animals · Water · Weather | Environmental science basics |
| **🌍 Advanced EVS** | Planets · Ecosystems · Human Body · Climate | Advanced environmental topics |
| **💻 Coding World** | Sequences · Loops · Conditions · Debugging · Patterns | Age-appropriate programming concepts |
| **🎨 Art World** | Color Mixing · Pattern Maker · Music Fun · Drawing School · Craft Corner | Creative expression modules |
| **🏃 Physical Activity** | Yoga · Dance · Stretching · Balance | Movement and exercise routines |
| **📇 Lesson Cards** | Flashcard topics across all subjects | Quick reference cards |

### 🎮 Gamification
- ⭐ **3-Star Rating** on every quiz (<%60 = 1★, 60–89% = 2★, 90%+ = 3★)
- 🎊 **Confetti Animation** when scoring 60%+ on any quiz
- 🏆 **Elastic Scale-In** animations on result screens
- 📈 **Staggered Tile Animations** — all "More Learning" tiles fade + slide in
- 🔊 **Sound Effects** — correct/incorrect answer audio feedback

### 👨‍👩‍👧 Parent & Teacher Dashboard
- View child progress across all subjects
- Set and change PIN lock
- AI Settings — configure AI provider and model
- Print Center — printable worksheets
- Class Tools (Teacher mode) — manage students and assignments

---

## 🛠 Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter 3.x** | Cross-platform UI framework |
| **Dart 3.x** | Programming language |
| **flutter_riverpod ^2.4.9** | State management |
| **go_router ^13.0.0** | Declarative routing |
| **hive ^2.2.3 + hive_flutter** | Local persistence (XP, Streaks, Scores) |
| **google_fonts ^6.1.0** | Nunito font family |
| **confetti ^0.7.0** | Confetti particle animations |
| **flutter_animate ^4.5.0** | Entrance & micro-animations |
| **flutter_tts ^4.0.2** | Text-to-speech for words |
| **audioplayers ^6.0.0** | Sound effects |
| **fl_chart ^0.66.0** | Progress charts in parent dashboard |
| **http ^1.2.0** | AI API calls (Gemini / OpenAI / Claude) |

---

## 🏗 Architecture

```
WordWorld AI uses a feature-first folder structure with a clean service layer.
```

### Layer Diagram

```
┌─────────────────────────────────────────────────────┐
│                    UI Layer                          │
│  features/   shared/widgets/   features/*/screens   │
├─────────────────────────────────────────────────────┤
│               State Management (Riverpod)            │
│           providers/app_providers.dart               │
├─────────────────────────────────────────────────────┤
│                   Service Layer                      │
│  StorageService · XPService · StreakService          │
│  AIService · TTSService · SoundService               │
│  HeartsService · FreemiumService · StreakService     │
├─────────────────────────────────────────────────────┤
│             Persistence (Hive)                       │
│  app_settings · progress · child_profiles · etc.    │
└─────────────────────────────────────────────────────┘
```

### Key Design Decisions

- **`StorageService`** is the single source of truth for all persistence — XP, streaks, module scores, child profiles, PIN, and AI settings all flow through it
- **`QuizResultScreen`** is a shared, reusable result widget used by every quiz module — avoids duplication across 18+ result use-sites
- **`_MoreTile`** uses `flutter_animate` with index-based delay for a beautiful cascading grid entrance effect
- **Adaptive Engine** adjusts question difficulty based on recent performance
- **AI Provider Abstraction** (`ai_provider.dart`) supports Gemini, OpenAI, Claude, or Mock — configurable from Parent Settings

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry point + Hive init
├── app.dart                         # MaterialApp + GoRouter setup
├── core/
│   ├── constants/                   # App-wide constants
│   ├── router/                      # app_router.dart — all 30+ routes
│   ├── services/
│   │   ├── storage_service.dart     # Hive persistence hub
│   │   ├── xp_service.dart          # XP & leveling
│   │   ├── streak_service.dart      # Daily streak tracking
│   │   ├── ai_service.dart          # AI prompt + response
│   │   ├── providers/               # Gemini, OpenAI, Claude, Mock
│   │   ├── tts_service.dart         # flutter_tts wrapper
│   │   ├── sound_service.dart       # audioplayers wrapper
│   │   └── ...
│   └── theme/
│       └── app_theme.dart           # AppColors, AppShadows, AppLevels
├── data/
│   ├── models/models.dart           # ChildProfile, ContentItem, etc.
│   └── seed/                        # words_a.dart … words_z.dart
├── features/
│   ├── kid/
│   │   ├── home/                    # KidHomeScreen with all nav tiles
│   │   ├── word_world/              # 6-tab deep-dive per word
│   │   ├── letter_world/            # A–Z letter screens
│   │   ├── math/                    # MathWorldScreen + AdvancedMathScreen
│   │   ├── evs/                     # EVSWorldScreen + AdvancedEVSScreen
│   │   ├── coding/                  # CodingWorldScreen (5 modules)
│   │   ├── art/                     # ArtWorldScreen (6 modules)
│   │   ├── language/                # Phonics, SightWords, Reading, Writing
│   │   ├── social/                  # LeaderboardScreen
│   │   ├── activities/              # PhysicalActivityScreen
│   │   └── shared/                  # LessonCardScreen
│   ├── onboarding/                  # Splash, Welcome, Login, Signup, Setup
│   ├── parent/                      # Dashboard, Settings, PrintCenter
│   ├── teacher/                     # Dashboard, ClassTools
│   └── membership/                  # FreemiumScreen
├── providers/
│   └── app_providers.dart           # All Riverpod providers
└── shared/
    └── widgets/
        ├── shared_widgets.dart      # PrimaryButton, BounceWidget, etc.
        └── quiz_result_screen.dart  # Reusable confetti result screen

test/
├── services_test.dart               # 21 unit tests (XPService, StreakService, StorageService)
└── widget_test.dart                 # 9 widget tests (QuizResultScreen)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.2.0
- Dart ≥ 3.0.0
- Android Studio / VS Code with Flutter extension

### 1. Clone the repo

```bash
git clone https://github.com/DeshuGoyel/wordworld-ai.git
cd wordworld-ai
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run on Chrome (Web)

```bash
flutter run -d chrome
```

### 4. Run on Android / iOS

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```

### 5. Build for production

```bash
# Web
flutter build web --release

# Android APK
flutter build apk --release
```

---

## 🧪 Running Tests

```bash
# All tests
flutter test

# Just unit/service tests
flutter test test/services_test.dart

# Just widget tests
flutter test test/widget_test.dart

# With verbose output
flutter test --reporter=expanded
```

### Test Coverage

| Test Suite | Tests | Coverage |
|-----------|-------|----------|
| `services_test.dart` | 21 tests | XPService, StreakService, StorageService module scores |
| `widget_test.dart` | 9 tests | QuizResultScreen — scores, callbacks, headlines |

---

## 🤖 AI Integration

WordWorld AI supports **multiple AI providers** switchable from Parent Settings:

| Provider | Model | Use Case |
|---------|-------|----------|
| **Google Gemini** | gemini-2.0-flash | Default — fast, free tier |
| **OpenAI** | gpt-4o-mini | High-quality responses |
| **Anthropic Claude** | claude-3-haiku | Safety-focused |
| **Mock** | Built-in | Offline / Demo mode |

AI powers:
- 📖 **Story generation** in Story Writing module
- 🗣️ **Ask Buddy** — conversational AI tutor
- 🎯 **Adaptive difficulty** — adjusts question sets based on performance
- 📝 **Personalized feedback** on written answers

To configure: tap the 🔒 lock on the home screen → enter parent PIN → AI Settings.

---

## 🗺 Roadmap

- [ ] **Multiplayer battles** — head-to-head quiz challenges
- [ ] **Offline mode** — full content caching for offline learning
- [ ] **Voice input** — answer questions by speaking
- [ ] **Print worksheets** — printable PDF activity sheets
- [ ] **Firebase sync** — cloud backup of child progress
- [ ] **Video lessons** — short animated explainer videos per topic
- [ ] **More languages** — Hindi, Spanish, French UI support

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ for kids everywhere  
**WordWorld AI** — *because every child deserves a world-class education*

⭐ Star this repo if you found it useful!

</div>
