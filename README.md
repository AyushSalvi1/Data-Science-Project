# ShopWave — AI-Powered Product Recommendation & Multi-Store Aggregator

[![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Google Gemini 2.5](https://img.shields.io/badge/Google_Gemini-2.5_Flash-4285F4?logo=google&logoColor=white)](https://ai.google.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL_RLS-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Tests](https://img.shields.io/badge/Tests-100%25_Passing-success)]()

**ShopWave** is a next-generation AI e-commerce product recommendation aggregator and multi-retailer intelligence platform. Built with **Flutter**, **Supabase (PostgreSQL with RLS)**, and a **FastAPI backend powered by Google Gemini 2.5 Flash**, ShopWave helps shoppers find the best verified deals across **Amazon India**, **Flipkart**, **Croma**, and partner merchants with transparent pricing, side-by-side comparisons, and direct purchase redirects.

---

## 🌟 Key Features

### 1. 📷 AI Visual Lens (Google Gemini 2.5 Flash Vision)
- **Photo-to-Product Search**: Snap a photo or upload from your gallery to identify any product.
- **Multimodal AI Matching**: Uses Google Gemini 2.5 Flash Vision to extract brand, category, specifications, and dominant visual attributes.
- **Internet Product Aggregation**: Searches and returns matching verified products available across top Indian retailers (Amazon India, Flipkart, Croma) with estimated INR pricing and direct merchant purchase links.
- **Cross-Platform**: Seamless memory-based image preview compatible with Flutter Web, Android, iOS, Windows, and macOS.

### 2. 🤖 AI Shopping Copilot (`lib/features/ai_assistant`)
- **Query-Specific Recommendations**: Conversational AI assistant understands any product category (footwear, laptops, smartphones, fashion, audio, home appliances) without bias or rigid defaults.
- **Natural Language Constraints**: Accurately extracts budgets (e.g. *"running shoes under 3000"*, *"gaming laptop below 75k"*), preferred brands, and technical requirements.
- **Explainable AI**: Accompanies each recommendation with analytical rationale (value-for-money, Bayesian review confidence, discount percentage).

### 3. 🌐 Multi-Store Aggregator & Merchant Purchase Redirects
- **Direct Merchant Purchases**: Replaced local retail carts with verified **"Buy on Retailer"** redirection buttons (`url_launcher`) for Amazon India, Flipkart, and Croma with affiliate tracking support.
- **Normalized Multi-Store Catalog**: Aggregates and standardizes titles, specs, ratings, review counts, stock status, and delivery timelines across retailers.

### 4. ⚖️ Interactive Price Comparison Matrix (`lib/features/comparison`)
- **Multi-Store Price Comparison**: Compare live prices for any product side-by-side across major stores.
- **Interactive Search & Quick Chips**: Instantly switch between popular searches (*Apple iPhone 15, Sony WH-1000XM5, MacBook Air, Running Shoes*) or enter custom search terms.
- **Deal Highlights**: Automatic tagging for **"BEST PRICE"**, **"TOP RATED"**, and **"Lowest Price Overall"**.

### 5. 🔍 Advanced Multi-Store Search & Filters (`lib/features/search`)
- **Store Filter Chips**: One-tap filtering across `All`, `Amazon India`, `Flipkart`, `Croma`, and `ShopWave`.
- **Price Range Sliders**: Numeric input for minimum and maximum budget ceilings.
- **Discount Filter**: Instant toggle to show only discounted items on sale.
- **Multi-Criteria Sorting**: Sort by Relevance, Price (Low to High), Price (High to Low), or Customer Rating.

### 6. ❤️ Supabase Personalization & Wishlist (`lib/features/wishlist`)
- **Persistent Wishlist**: Save favorite products with instant optimistic UI updates and cloud persistence to Supabase PostgreSQL (`wishlists` table).
- **User Preference Tracking**: Tracks user likes and dislikes to power personalized product recommendations and price drop alerts.
- **Direct Comparison from Wishlist**: Tap "Compare Prices Across Stores" directly on any saved item.

### 7. 📉 Historical Price Tracking & Drop Alerts (`lib/features/price_tracking`)
- **30-Day Interactive Timeline**: Visual pricing history graph showing price drops, lowest recorded price, and 30-day average.
- **Price Drop Subscriptions**: Subscribe to notifications when a product reaches a user's target price.

### 8. 📮 International PIN / Zip Code Validation (`lib/features/address`)
- Flexible address validation supporting both 6-digit Indian Postal PIN codes (e.g., `400001`) and 5-digit US ZIP codes without errors.

### 9. 📴 Complete Offline Resilience (`lib/core/services/offline_cache_service.dart`)
- Persistent local caching via `SharedPreferences`. The app functions reliably even during network outages, seamlessly retaining wishlist states and catalog data.

---

## 🛠️ Architecture & Tech Stack

```
ShopWave Architecture
├── Flutter Frontend (Mobile & Web)
│   ├── State Management: flutter_bloc 9.0 (UserBloc, WishlistBloc, SearchBloc, etc.)
│   ├── Service Locator: get_it (Dependency Injection)
│   ├── Navigation: go_router with StatefulShellRoute
│   ├── Networking & Env: http, flutter_dotenv
│   ├── Image Processing: image_picker (cross-platform Uint8List byte buffers)
│   └── Merchant Redirect: url_launcher
│
├── FastAPI AI Orchestrator (Backend)
│   ├── Framework: FastAPI + Uvicorn + Pydantic v2
│   ├── Vision Model: Google Gemini 2.5 Flash Multimodal Vision
│   ├── Language Model: Google Gemini 2.5 Flash Generative AI
│   ├── Recommendation Engine: Hybrid Scoring + Bayesian Rating Weighting
│   └── Providers: Amazon India, Flipkart, Croma, ShopWave adapters
│
└── Supabase (Cloud Database & Auth)
    ├── PostgreSQL with Row Level Security (RLS)
    └── Tables: users, products, categories, wishlists, product_reviews,
                price_history, price_alerts, user_preferences
```

---

## 🚀 Getting Started

### 1. Prerequisites
- **Flutter SDK**: 3.27+ / 3.47+
- **Python**: 3.10+
- **Google Gemini API Key**: [Get API Key](https://ai.google.dev/)
- **Supabase Account**: (URL and Anon Key)

### 2. Configure Environment (`.env`)
Create or edit `.env` in the repository root:
```env
# Supabase Configuration
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANNONKEY=your-supabase-anon-key

# AI Configuration
GEMINI_API_KEY=your_gemini_api_key_here

# Backend URL (use localhost for web/desktop, 10.0.2.2 for Android emulator)
BACKEND_API_URL=http://localhost:8000
```

### 3. Run FastAPI AI Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
Interactive Swagger documentation available at: `http://localhost:8000/docs`

### 4. Run Flutter Application
```bash
flutter pub get
flutter run -d chrome      # Web
# or
flutter run -d windows     # Windows Desktop
# or
flutter run                # Android / iOS device
```

---

## 🧪 Automated Testing & Code Quality

Both the backend and Flutter frontend include full test suites:

### Flutter Static Analysis
```bash
flutter analyze
```
- **0 errors, 0 warnings** across the entire codebase.

### Flutter Test Suite
```bash
flutter test --no-pub
```
- **All 18 tests passing**:
  - `WishlistBloc` state machine & optimistic updates
  - `MultiRetailerProductModel` JSON serialization & fallback parsing
  - `AIAssistantRepository` budget & intent extraction
  - `OfflineCacheService` local caching & preference retention
  - `RetailerBadge` widget styling across stores

### Backend Test Suite
```bash
python -m pytest backend/tests/test_backend.py
```
- **6 unit tests passing** covering multi-retailer aggregation, Bayesian rating scoring, constraint enforcement, comparison matrix calculation, and price history analytics.

---

## 📖 Comprehensive User Manual
A publication-quality 4-page PDF user manual is included in the root directory:
- **File**: `ShopWave_Comprehensive_User_Manual.pdf`
- Contains complete feature walkthroughs, UI flows, AI prompting tips, troubleshooting guides, and API specifications.

---

## 📄 License
This project is licensed under the MIT License.
