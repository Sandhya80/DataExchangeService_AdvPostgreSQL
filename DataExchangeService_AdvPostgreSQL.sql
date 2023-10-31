

-- Who's Here?
-- task 1:
SELECT rolname
FROM pg_roles
WHERE rolsuper = true;

-- task 2:
SELECT *
FROM pg_roles
WHERE rolsuper = false;

-- task 3:
SELECT current_role;

-- Adding a Publisher:
-- task 4:
CREATE ROLE abc_open_data
WITH NOSUPERUSER LOGIN;

-- task 5:
CREATE ROLE publishers
WITH NOSUPERUSER
ROLE abc_open_data;

-- Granting a Publisher Access to Analytics:
-- task 6:
GRANT USAGE ON SCHEMA analytics
TO publishers;

-- task 7:
GRANT SELECT ON ALL TABLES IN SCHEMA analytics
TO publishers;

-- task 8:
SELECT * FROM information_schema.table_privileges
WHERE grantee = 'publishers';

-- task 9:
SET ROLE abc_open_data;

SELECT * FROM analytics.downloads LIMIT 10;

-- Granting a Publisher Access to Dataset Listings:
-- task 10:
SET ROLE ccuser;

SELECT * FROM directory.datasets LIMIT 5;

-- task 11:
GRANT USAGE ON SCHEMA directory TO publishers;

-- task 12:
GRANT SELECT (id, create_date, hosting_path, publisher, src_size) ON directory.datasets to publishers;

-- task 13:
SET ROLE abc_open_data;

/*SELECT id, publisher, hosting_path, data_checksum
FROM directory.datasets; */

SELECT id, publisher, hosting_path 
FROM directory.datasets;

-- Adding Row Level Security on Downloads Data:
-- task 14:
SET ROLE ccuser;

CREATE POLICY publishers_privacy 
ON analytics.downloads
FOR SELECT TO publishers 
USING (owner=current_user);

ALTER TABLE analytics.downloads ENABLE ROW LEVEL SECURITY;

-- task 15:
SELECT * FROM analytics.downloads
LIMIT 5;

SET ROLE abc_open_data;

SELECT * FROM analytics.downloads
LIMIT 5;

SET ROLE ccuser;


