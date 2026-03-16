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
