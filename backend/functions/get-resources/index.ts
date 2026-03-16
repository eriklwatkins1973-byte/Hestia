import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ---------------------------------------------------------------------------
// get-resources edge function
//
// Returns active resources filtered by state_code, optionally by county_id
// and/or category.  Supports incremental sync via updated_after parameter.
//
// Query parameters:
//   state_code    (required) – 2-letter state abbreviation
//   county_id     (optional) – UUID of the county
//   category      (optional) – resource category slug
//   updated_after (optional) – ISO-8601 timestamp for incremental sync
//   page          (optional) – 1-based page number (default: 1)
//   page_size     (optional) – records per page (default: 50, max: 200)
// ---------------------------------------------------------------------------

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  // Handle preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  try {
    const url = new URL(req.url);
    const stateCode = url.searchParams.get("state_code");
    const countyId = url.searchParams.get("county_id");
    const category = url.searchParams.get("category");
    const updatedAfter = url.searchParams.get("updated_after");
    const page = Math.max(1, parseInt(url.searchParams.get("page") ?? "1", 10));
    const pageSize = Math.min(
      200,
      Math.max(1, parseInt(url.searchParams.get("page_size") ?? "50", 10))
    );

    if (!stateCode) {
      return new Response(
        JSON.stringify({ error: "state_code query parameter is required" }),
        { status: 400, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
      );
    }

    // Initialise Supabase using the service role so RLS doesn't interfere with
    // the edge function itself.  The function still enforces the state filter.
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Resolve state id
    const { data: stateRow, error: stateErr } = await supabase
      .from("states")
      .select("id")
      .eq("code", stateCode.toUpperCase())
      .single();

    if (stateErr || !stateRow) {
      return new Response(
        JSON.stringify({ error: `State '${stateCode}' not found` }),
        { status: 404, headers: { ...CORS_HEADERS, "Content-Type": "application/json" } }
      );
    }

    // Build resource query
    let query = supabase
      .from("resources")
      .select(
        `id, name, category, sub_category, description,
         address_line1, city, zip_code, phone, website, email,
         latitude, longitude, status, hours, meal_schedules,
         last_verified_at, updated_at,
         county_id`
      )
      .eq("state_id", stateRow.id)
      .eq("status", "active")
      .order("name")
      .range((page - 1) * pageSize, page * pageSize - 1);

    if (countyId) query = query.eq("county_id", countyId);
    if (category) query = query.eq("category", category);
    if (updatedAfter) query = query.gt("updated_at", updatedAfter);

    const { data, error, count } = await query;

    if (error) throw error;

    return new Response(
      JSON.stringify({
        data,
        meta: {
          page,
          page_size: pageSize,
          total: count ?? data?.length ?? 0,
          state_code: stateCode.toUpperCase(),
        },
      }),
      {
        status: 200,
        headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
      }
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
    });
  }
});
