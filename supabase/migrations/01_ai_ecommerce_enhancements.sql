-- ====================================================================
-- ShopWave AI E-Commerce Recommendation System Database Migration
-- Migration 01: Wishlist, Reviews, Price History, Alerts, and RLS Policies
-- ====================================================================

-- 1. Enable RLS on core tables
ALTER TABLE IF EXISTS public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.categories ENABLE ROW LEVEL SECURITY;

-- 2. Create Wishlist Table
CREATE TABLE IF NOT EXISTS public.wishlists (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT wishlists_pkey PRIMARY KEY (id),
    CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
    CONSTRAINT wishlists_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE,
    CONSTRAINT wishlists_user_product_unique UNIQUE (user_id, product_id)
);
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

-- 3. Create Product Reviews Table
CREATE TABLE IF NOT EXISTS public.product_reviews (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rating double precision NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    comment text,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT product_reviews_pkey PRIMARY KEY (id),
    CONSTRAINT product_reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE,
    CONSTRAINT product_reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
    CONSTRAINT product_reviews_user_product_unique UNIQUE (product_id, user_id)
);
ALTER TABLE public.product_reviews ENABLE ROW LEVEL SECURITY;

-- 4. Create Price History Table (for Price Tracking & Analytics)
CREATE TABLE IF NOT EXISTS public.price_history (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL,
    price double precision NOT NULL,
    retailer character varying NOT NULL DEFAULT 'ShopWave',
    recorded_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT price_history_pkey PRIMARY KEY (id),
    CONSTRAINT price_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_price_history_product_time ON public.price_history(product_id, recorded_at DESC);
ALTER TABLE public.price_history ENABLE ROW LEVEL SECURITY;

-- 5. Create Price Drop Alerts Table
CREATE TABLE IF NOT EXISTS public.price_alerts (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    target_price double precision NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT price_alerts_pkey PRIMARY KEY (id),
    CONSTRAINT price_alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
    CONSTRAINT price_alerts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE
);
ALTER TABLE public.price_alerts ENABLE ROW LEVEL SECURITY;

-- 6. Create User Shopping Preferences Table (for Personalization)
CREATE TABLE IF NOT EXISTS public.user_preferences (
    user_id uuid NOT NULL,
    budget_preference double precision,
    preferred_categories text[] DEFAULT '{}',
    preferred_retailers text[] DEFAULT '{}',
    price_drop_alerts_enabled boolean DEFAULT true,
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT user_preferences_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
);
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

-- ====================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ====================================================================

-- Users Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Public profiles are viewable by everyone') THEN
        CREATE POLICY "Public profiles are viewable by everyone" ON public.users FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Users can update their own profile') THEN
        CREATE POLICY "Users can update their own profile" ON public.users FOR UPDATE USING (auth.uid() = id);
    END IF;
END $$;

-- Addresses Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'addresses' AND policyname = 'Users can manage their own addresses') THEN
        CREATE POLICY "Users can manage their own addresses" ON public.addresses FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- Carts Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'carts' AND policyname = 'Users can manage their own cart') THEN
        CREATE POLICY "Users can manage their own cart" ON public.carts FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- Wishlists Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'wishlists' AND policyname = 'Users can manage their own wishlist') THEN
        CREATE POLICY "Users can manage their own wishlist" ON public.wishlists FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- Reviews Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'product_reviews' AND policyname = 'Reviews are readable by everyone') THEN
        CREATE POLICY "Reviews are readable by everyone" ON public.product_reviews FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'product_reviews' AND policyname = 'Users can insert their own reviews') THEN
        CREATE POLICY "Users can insert their own reviews" ON public.product_reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'product_reviews' AND policyname = 'Users can update their own reviews') THEN
        CREATE POLICY "Users can update their own reviews" ON public.product_reviews FOR UPDATE USING (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'product_reviews' AND policyname = 'Users can delete their own reviews') THEN
        CREATE POLICY "Users can delete their own reviews" ON public.product_reviews FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;

-- Price History Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'price_history' AND policyname = 'Price history is readable by everyone') THEN
        CREATE POLICY "Price history is readable by everyone" ON public.price_history FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'price_history' AND policyname = 'Vendors and admins can record price history') THEN
        CREATE POLICY "Vendors and admins can record price history" ON public.price_history FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
    END IF;
END $$;

-- Price Alerts Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'price_alerts' AND policyname = 'Users can manage their own price alerts') THEN
        CREATE POLICY "Users can manage their own price alerts" ON public.price_alerts FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- User Preferences Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_preferences' AND policyname = 'Users can manage their own preferences') THEN
        CREATE POLICY "Users can manage their own preferences" ON public.user_preferences FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- Products & Images Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'products' AND policyname = 'Products are readable by all') THEN
        CREATE POLICY "Products are readable by all" ON public.products FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'product_images' AND policyname = 'Product images are readable by all') THEN
        CREATE POLICY "Product images are readable by all" ON public.product_images FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Categories are readable by all') THEN
        CREATE POLICY "Categories are readable by all" ON public.categories FOR SELECT USING (true);
    END IF;
END $$;

-- Orders Policies
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Users can view their own orders') THEN
        CREATE POLICY "Users can view their own orders" ON public.orders FOR SELECT USING (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'orders' AND policyname = 'Users can create orders') THEN
        CREATE POLICY "Users can create orders" ON public.orders FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'order_items' AND policyname = 'Users can view their own order items') THEN
        CREATE POLICY "Users can view their own order items" ON public.order_items FOR SELECT USING (
            EXISTS (
                SELECT 1 FROM public.orders o
                WHERE o.id = public.order_items.order_id AND o.user_id = auth.uid()
            )
        );
    END IF;
END $$;
