# ShopWave — AI-Powered E-Commerce Recommendation & Multi-Store Platform

ShopWave is an intelligent e-commerce mobile application and multi-retailer recommendation engine built with **Flutter**, **Supabase (PostgreSQL with RLS)**, and a **FastAPI AI Orchestration Backend**.

Beyond traditional shopping capabilities, ShopWave provides a multi-retailer intelligence layer that searches across **Amazon India**, **Flipkart**, **Croma**, and **ShopWave**, provides side-by-side comparative matrices, conversational AI shopping assistance, image-based visual product matching, historical price tracking with drop alerts, and complete offline resiliency.

---

## 🌟 Key Capabilities & New Features

### 1. 🤖 AI Shopping Assistant (`lib/features/ai_assistant`)
- **Natural Language Parsing**: Understands queries with budget limits (e.g. *"Best smartphone under 20k with good camera"*), intent, brand, and specifications.
- **Transparent Explanations**: Accompanies every recommendation with justifiable rationale (e.g. *"Ranked #1 due to highest Bayesian rating score and 18% savings vs competitors"*).
- **Interactive Chat Interface**: Quick suggestion chips, direct product preview cards, side-by-side compare shortcuts, and merchant redirects.

### 2. 🌐 Multi-Website Product Search (`lib/features/multi_retailer`)
- **Authorized Feeds & Retailers**: Aggregates product listings from **Amazon India**, **Flipkart**, **Croma**, and **ShopWave**.
- **Unified Schema**: Normalizes cross-store titles, categories, pricing, discounts, ratings, review counts, and stock availability.
- **Store Badges**: Distinct visual badges for each authorized retailer with store branding.
- **Affiliate & Direct Redirects**: Working merchant redirection powered by `url_launcher` with tracking identifiers and fallback safe browser opening.

### 3. ⚖️ Side-by-Side Product Comparison (`lib/features/comparison`)
- **Comparison Matrix**: Side-by-side analysis of key attributes:
  - Best Price & Savings relative to MRP.
  - User review ratings and confidence.
  - Delivery timelines and warranty/return terms.
  - Key specifications.
- **Top 3 Overall & Store Best Picks**: Surfaces the single best offer per merchant and summarizes the final verdict.

### 4. 📷 Image-Based Visual Search (`lib/features/visual_search`)
- **Camera & Gallery Support**: Snap a photo or upload from the device gallery.
- **Attribute & Embedding Extraction**: Detects visual attributes, categories, and tags.
- **Cross-Retailer Visual Matching**: Computes visual similarity scores and presents matched catalog items.

### 5. 🎯 Personalized Hybrid Recommendation Engine (`backend/services/recommendation_service.py`)
- **Multi-Factor Scoring**:
  $$\text{Score} = w_{\text{rel}} \cdot \text{Relevance} + w_{\text{price}} \cdot \text{PriceScore} + w_{\text{rating}} \cdot \text{BayesianRating} + w_{\text{history}} \cdot \text{HistoryBonus}$$
- **Bayesian Rating Confidence**: Incorporates review count confidence into ratings so high-volume 4.5★ beats low-volume 5.0★.
- **Hard Constraints**: Strict enforcement of budget maximums and category requirements.

### 6. 📉 Price Tracking & Drop Alerts (`lib/features/price_tracking`)
- **Interactive Price Timeline**: 30-day timestamped pricing graph with lowest, highest, and average metrics.
- **Trend Detection**: Automatically identifies if prices are dropping, stable, or rising.
- **Price-Drop Subscriptions**: Toggle alerts for target price drops backed by database subscriptions (`price_alerts`).

### 7. 🛍️ Complete Shopping Core
- **Wishlist CRUD** (`lib/features/wishlist`): Add/remove products with instant optimistic updates, offline caching, and heart overlays on cards.
- **Product Reviews & Ratings** (`lib/features/review`): Interactive star rating bar chart, review count distribution, and verified submission modal.
- **Advanced Filtering & Sorting** (`lib/features/search`): Multi-store toggle, price range min/max sliders, and sort by relevance, price, or rating.
- **User Profile & Preferences** (`lib/features/user/pages/edit_profile_page.dart`): Update profile names, set default shopping budget, and select preferred retailers.
- **Operational Customer Modals**: Interactive dialogs for Saved Payment Methods, FAQs, and Customer Support.

### 8. 📴 Zero-Connectivity Offline Resiliency (`lib/core/services/offline_cache_service.dart`)
- Full offline caching using `SharedPreferences`.
- Seamlessly retrieves cached catalog items, wishlist state, user preferences, and search history during network outages.

---

## 🛠️ Architecture & Tech Stack

```
ShopWave Architecture
├── Flutter Mobile App (Frontend)
│   ├── State Management: flutter_bloc 9.0 (UserBloc, WishlistBloc, SearchBloc, etc.)
│   ├── Service Locator: get_it (Dependency Injection)
│   ├── Navigation: go_router
│   ├── Networking & Caching: http, shared_preferences, flutter_dotenv
│   └── Deep Links & Launching: url_launcher
│
├── FastAPI AI Orchestrator (Backend)
│   ├── Framework: FastAPI + Uvicorn + Pydantic v2
│   ├── Recommendation Service: Hybrid scoring + Bayesian confidence
│   ├── Assistant Service: Natural language intent & budget parsing
│   ├── Providers: Amazon India, Flipkart, Croma, ShopWave adapters
│   └── Comparison & Visual Search: Multi-attribute matrix algorithms
│
└── Supabase (Cloud Database & Auth)
    ├── PostgreSQL with Row Level Security (RLS)
    ├── Auth: Supabase Auth with custom user roles (customer, vendor, admin)
    └── Tables: users, products, categories, carts, orders, addresses,
                wishlists, product_reviews, price_history, price_alerts, user_preferences
```

---

## 🗄️ Database Enhancements (`supabase/migrations/`)

Added complete PostgreSQL schema and RLS policies in `supabase/migrations/01_ai_ecommerce_enhancements.sql`:

1. **`wishlists`**: User wishlist storage with unique composite index `(user_id, product_id)`.
2. **`product_reviews`**: Verified user reviews, ratings (1-5), and timestamps.
3. **`price_history`**: Historical price tracking timeline entries for analytics.
4. **`price_alerts`**: User price-drop subscriptions with target thresholds.
5. **`user_preferences`**: User budget limits, preferred retailers, and alert settings.
6. **Row Level Security (RLS)**: Strict tenant isolation enabled on all tables allowing users to modify only their own records.

---

## 🚀 Getting Started

### 1. Prerequisites
- **Flutter SDK**: 3.27+ / 3.47+
- **Python**: 3.10+ (for FastAPI backend)
- **Supabase Account**: (URL and Anon Key)

### 2. Configure Environment (`.env`)
Create or edit `.env` in the repository root:
```env
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANNONKEY=your-supabase-anon-key
BACKEND_API_URL=http://10.0.2.2:8000   # Use http://localhost:8000 for web/desktop, 10.0.2.2 for Android emulator
```

### 3. Run FastAPI AI Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
Interactive Swagger API documentation will be available at: `http://localhost:8000/docs`

### 4. Run Flutter Mobile App
```bash
flutter pub get
flutter run
```

---

## 🧪 Automated Testing

Both the backend and Flutter frontend include automated test suites:

### Running Flutter Tests
```bash
flutter test
```
- **18 unit and widget tests** covering:
  - `WishlistBloc` state machine and optimistic updates
  - `MultiRetailerProductModel` JSON serialization and fallback parsing
  - `AIAssistantRepository` budget and intent extraction
  - `OfflineCacheService` local caching and preference retention
  - `RetailerBadge` widget styling across Amazon, Flipkart, and Croma

### Running Backend Tests
```bash
python -m pytest backend/tests/test_backend.py
```
- **6 passed unit tests** covering:
  - Multi-retailer aggregation and filtering
  - Bayesian rating score computation
  - Hard constraint enforcement (budget ceilings)
  - Side-by-side comparison matrix generation
  - Natural language assistant intent parsing
  - Historical price analytics and drop alerts

### Analyzer Status
```bash
flutter analyze
```
- **0 errors, 0 warnings** across the entire codebase.

---

## 📄 License
This project is licensed under the MIT License.
