import { createClient } from '@supabase/supabase-js';
const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
export const supabaseAdmin = url && key ? createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false}}) : null;
export const isProductionMode = process.env.NEXT_PUBLIC_APP_MODE === 'production';
