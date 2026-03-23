-- Enable Row-Level Security on the resources table so that every row access
-- is subject to the policies defined below.
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

-- Anyone (authenticated or anonymous) may read resources.
CREATE POLICY "Allow public read access" ON resources
  FOR SELECT
  USING (true);

-- Only authenticated users whose JWT contains `"role": "admin"` may
-- INSERT, UPDATE, or DELETE resources.
CREATE POLICY "Allow authenticated admins to modify" ON resources
  FOR ALL
  TO authenticated
  USING (auth.jwt() ->> 'role' = 'admin');

-- 1. Enable RLS on all tables
ALTER TABLE states ENABLE ROW LEVEL SECURITY;
ALTER TABLE counties ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

-- 2. Public Read Access (Allows the app to show data to anyone)
CREATE POLICY "Allow public read-only access" 
ON resources FOR SELECT 
USING (true);

-- 3. Multi-Tenant Write Access (The 'Born-Compliant' Security)
-- This ensures an admin can only edit resources belonging to their assigned county
CREATE POLICY "Admins can only update their own county resources" 
ON resources FOR UPDATE 
TO authenticated
USING (
  auth.jwt() ->> 'county_id' = county_id::text
);

-- 4. Multi-Tenant Delete Access
CREATE POLICY "Admins can only delete their own county resources" 
ON resources FOR DELETE 
TO authenticated
USING (
  auth.jwt() ->> 'county_id' = county_id::text
);
