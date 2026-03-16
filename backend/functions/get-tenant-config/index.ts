import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ---------------------------------------------------------------------------
// get-tenant-config edge function
//
// Returns the branding/configuration for a given state.
//
// Query parameters:
//   state_code (required) – 2-letter state abbreviation
// ---------------------------------------------------------------------------

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  try {
    const url = new URL(req.url);
    const stateCode = url.searchParams.get("state_code");

    if (!stateCode) {
      return new Response(
        JSON.stringify({ error: "state_code query parameter is required" }),
        { status: 400, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    const { data, error } = await supabase
      .from("tenant_configs")
      .select(
        "state_code, state_name, primary_color, accent_color, logo_url, support_email, resource_categories"
      )
      .eq("state_code", stateCode.toUpperCase())
      .eq("is_active", true)
      .single();

    if (error || !data) {
      return new Response(
        JSON.stringify({ error: `Tenant config for '${stateCode}' not found` }),
        { status: 404, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
      );
    }

    return new Response(JSON.stringify({ data }), {
      status: 200,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  }
});
