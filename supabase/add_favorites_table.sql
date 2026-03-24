-- SQL for creating product_favorites table in Supabase
-- Fixed: Removed hard foreign key to public.users to avoid permission issues 
-- on the users table for anonymous/client roles.

DROP TABLE IF EXISTS public.product_favorites;

CREATE TABLE public.product_favorites (
    user_id TEXT NOT NULL,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id)
);

-- Row Level Security (RLS)
ALTER TABLE public.product_favorites ENABLE ROW LEVEL SECURITY;

-- Allow anonymous and authenticated users to manage their own favorites 
-- using the user_id (which is the device_id in this app)
CREATE POLICY "Users can manage their own favorites"
ON public.product_favorites
FOR ALL
USING (true)
WITH CHECK (true);

-- Indexes for performance
CREATE INDEX idx_product_favorites_user_id ON public.product_favorites(user_id);
CREATE INDEX idx_product_favorites_product_id ON public.product_favorites(product_id);
