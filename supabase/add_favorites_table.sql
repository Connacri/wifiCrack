
-- SQL for creating product_favorites table in Supabase
-- Run this in your Supabase SQL Editor.

CREATE TABLE IF NOT EXISTS public.product_favorites (
    user_id TEXT NOT NULL REFERENCES public.users(device_id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, product_id)
);

-- Row Level Security (RLS)
ALTER TABLE public.product_favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own favorites"
ON public.product_favorites
FOR ALL
USING (auth.uid()::text = user_id OR (NOT (SELECT EXISTS (SELECT 1 FROM auth.users)) AND TRUE)); 
-- Note: The above policy is a bit relaxed for guest users using device_id. 
-- If you use Firebase/Supabase Auth, use:
-- USING (auth.uid() = user_id);

-- Indexes for performance
CREATE INDEX idx_product_favorites_user_id ON public.product_favorites(user_id);
CREATE INDEX idx_product_favorites_product_id ON public.product_favorites(product_id);
