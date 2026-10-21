-- Idempotent core schema derived from supabase.sql.
-- Tables are created in foreign-key order so a fresh database succeeds.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;

-- users, categories, products, product_images, addresses, carts, orders, order_items

CREATE TABLE IF NOT EXISTS public.users (
  id uuid NOT NULL,
  username character varying NOT NULL,
  name character varying NULL,
  email character varying NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  role character varying NULL DEFAULT 'customer'::character varying,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_email_key UNIQUE (email),
  CONSTRAINT users_username_key UNIQUE (username)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  image_url character varying NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.products (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NULL,
  description character varying NULL,
  price double precision NULL,
  discount_price double precision NULL,
  category_id uuid NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  quantity bigint NULL,
  vendor_id uuid NULL,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id),
  CONSTRAINT products_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.users(id)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.product_images (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  image_url character varying NULL,
  product_id uuid NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT product_images_pkey PRIMARY KEY (id),
  CONSTRAINT product_images_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.addresses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  address character varying NULL,
  state character varying NULL,
  city character varying NULL,
  user_id uuid NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  zip_code character varying NULL,
  CONSTRAINT address_pkey PRIMARY KEY (id),
  CONSTRAINT address_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.carts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NULL,
  quantity bigint NULL,
  user_id uuid NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT carts_pkey PRIMARY KEY (id),
  CONSTRAINT carts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT carts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.orders (
  id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  user_id uuid NULL,
  status text NULL DEFAULT 'pending'::text,
  total_price numeric NOT NULL,
  payment_status text NULL DEFAULT 'unpaid'::text,
  payment_method text NULL,
  created_at timestamp without time zone NULL DEFAULT now(),
  shipping_address uuid NULL DEFAULT gen_random_uuid(),
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_shipping_address_fkey FOREIGN KEY (shipping_address) REFERENCES public.addresses(id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT orders_payment_method_check CHECK ((payment_method = ANY (ARRAY['cash_on_delivery'::text, 'credit_card'::text, 'paypal'::text]))),
  CONSTRAINT orders_payment_status_check CHECK ((payment_status = ANY (ARRAY['paid'::text, 'unpaid'::text, 'refunded'::text]))),
  CONSTRAINT orders_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'confirmed'::text, 'delivered'::text, 'cancelled'::text])))
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.order_items (
  id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  order_id uuid NULL,
  product_id uuid NULL,
  quantity integer NOT NULL,
  price numeric NOT NULL,
  sub_total numeric GENERATED ALWAYS AS (((quantity)::numeric * price)) STORED NULL,
  created_at timestamp without time zone NULL DEFAULT now(),
  CONSTRAINT order_items_pkey PRIMARY KEY (id),
  CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE,
  CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
) TABLESPACE pg_default;

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

CREATE OR REPLACE FUNCTION public.get_vendor_orders(vendor_uuid uuid)
RETURNS SETOF json AS $$
BEGIN
  RETURN QUERY
  SELECT json_build_object(
    'id', o.id,
    'created_at', o.created_at,
    'status', o.status,
    'payment_status', o.payment_status,
    'payment_method', o.payment_method,
    'total_price', order_agg.total_price,
    'shipping_address', a,
    'order_items', order_agg.oi_items
  )
  FROM orders o
  JOIN addresses a ON o.shipping_address = a.id
  JOIN (
    SELECT
      oi.order_id,
      SUM(oi.quantity * COALESCE(p.discount_price, p.price)) AS total_price,
      json_agg(
        json_build_object(
          'order_item_id', oi.id,
          'quantity', oi.quantity,
          'product', json_build_object(
            'id', p.id,
            'name', p.name,
            'description', p.description,
            'price', p.price,
            'discount_price', p.discount_price,
            'quantity', p.quantity,
            'images', (
              SELECT COALESCE(json_agg(
                json_build_object(
                  'id', pi.id,
                  'image_url', pi.image_url
                )
              ), '[]'::json)
              FROM product_images pi
              WHERE pi.product_id = p.id
            )
          )
        )
      ) AS oi_items
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    WHERE p.vendor_id = vendor_uuid
    GROUP BY oi.order_id
  ) AS order_agg ON o.id = order_agg.order_id
  WHERE o.id IN (
    SELECT oi.order_id
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    WHERE p.vendor_id = vendor_uuid
  )
  ORDER BY o.created_at DESC;
END;
$$ LANGUAGE plpgsql;

GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_vendor_orders(uuid) TO anon, authenticated, service_role;

-- Write policies the app needs and that 01_ai_ecommerce_enhancements.sql does not create.

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'users' AND policyname = 'Users can insert their own profile') THEN
        CREATE POLICY "Users can insert their own profile" ON public.users FOR INSERT WITH CHECK (auth.uid() = id);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'categories' AND policyname = 'Authenticated users can insert categories') THEN
        CREATE POLICY "Authenticated users can insert categories" ON public.categories FOR INSERT TO authenticated WITH CHECK (auth.uid() IS NOT NULL);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'products' AND policyname = 'Vendors can insert their own products') THEN
        CREATE POLICY "Vendors can insert their own products" ON public.products FOR INSERT WITH CHECK (auth.uid() = vendor_id);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'product_images' AND policyname = 'Vendors can insert images for their products') THEN
        CREATE POLICY "Vendors can insert images for their products" ON public.product_images FOR INSERT WITH CHECK (
            EXISTS (
                SELECT 1 FROM public.products p
                WHERE p.id = product_id AND p.vendor_id = auth.uid()
            )
        );
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'order_items' AND policyname = 'Users can insert items for their own orders') THEN
        CREATE POLICY "Users can insert items for their own orders" ON public.order_items FOR INSERT WITH CHECK (
            EXISTS (
                SELECT 1 FROM public.orders o
                WHERE o.id = order_id AND o.user_id = auth.uid()
            )
        );
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'public' AND tablename = 'orders' AND policyname = 'Users can update their own orders') THEN
        CREATE POLICY "Users can update their own orders" ON public.orders FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

INSERT INTO storage.buckets (id, name, public)
VALUES ('ecommerce-storage', 'ecommerce-storage', true)
ON CONFLICT (id) DO NOTHING;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Public read ecommerce-storage') THEN
        CREATE POLICY "Public read ecommerce-storage" ON storage.objects FOR SELECT USING (bucket_id = 'ecommerce-storage');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects' AND policyname = 'Authenticated upload ecommerce-storage') THEN
        CREATE POLICY "Authenticated upload ecommerce-storage" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'ecommerce-storage');
    END IF;
END $$;

-- Creates public.users when Auth creates an account. Email confirmation has no
-- session yet, so the app cannot insert this row itself under row-level security.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (id, email, name, username)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'name', ''),
    COALESCE(
      NULLIF(NEW.raw_user_meta_data->>'username', ''),
      split_part(NEW.email, '@', 1) || floor(random() * 1000000)::int::text
    )
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

INSERT INTO public.users (id, email, name, username)
SELECT
  u.id,
  u.email,
  COALESCE(u.raw_user_meta_data->>'name', ''),
  COALESCE(
    NULLIF(u.raw_user_meta_data->>'username', ''),
    split_part(u.email, '@', 1) || floor(random() * 1000000)::int::text
  )
FROM auth.users u
WHERE NOT EXISTS (SELECT 1 FROM public.users p WHERE p.id = u.id)
ON CONFLICT (id) DO NOTHING;
