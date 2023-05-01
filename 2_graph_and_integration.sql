-- Activate postgis if not done so yet
CREATE EXTENSION postgis;

-- Activate extension after installing pg routing
CREATE EXTENSION pgrouting;

-- Check if versions of packages correctly installed
SELECT PostGIS_full_version();
SELECT pgr_version();

-- Change Open Street Maps Road dataset id column to bigint type from text
ALTER TABLE ga_roads ALTER COLUMN osm_id type bigint USING osm_id::bigint;

-- Create columns source and target for pg routing to identify for functions that will be used
ALTER TABLE ga_roads ADD COLUMN source bigint;
ALTER TABLE ga_roads ADD COLUMN target bigint;

-- Address issues where edge makes connection with another right in the middle and still causing them to be disconnected
-- Use pgr_nodeNetwork to split segments into needed new segments
-- It creates table called "tablename_noded" within the database
-- parameter order and format is:
-- text, double precision, id text, the_geom text, table_ending text, rows_where text, outall boolean) 
SELECT pgr_nodeNetwork('ga_roads', 0.0001, 'osm_id', 'geometry');

-- Create new ga_roads table with the newly created edges table and the old data from original ga_roads table
-- This is needed because the function above created a table that is missing a lot of the information from ga_roads
SELECT 
	n.id, n.old_id, n.sub_id, n.source, n.target, r.code,
	-- Also, add cost column to edges (roads) table, then set it to length of geometry
	st_length(n.geometry) as cost,
	r.fclass, r.name, r.ref, r.oneway, r.maxspeed, 
	r.layer, r.bridge, r.tunnel, r.distance, 
	r.distance_miles, r.minutes, n.geometry
INTO ga_roads_updated
FROM ga_roads_noded as n
INNER JOIN ga_roads as r
ON n.old_id = r.osm_id;

-- Apply function pgr_create topology that creates a vertices table as "tablename_vertices_pgr"
-- The function has to be set with "edge table name", tolerance rate (Selected one is from demo provided by pg routing),
-- corresponding geometry column name, and corresponding edge id column
SELECT pgr_createTopology('ga_roads_updated', 0.0001, 'geometry', 'id');

-- Create table integrating hospitals into roads within Georgia by finding the closest 3 roads to each hospital
SELECT
  h.objectid as hospitalid,
  CA.id as roadid,
  CA.source,
  CA.target,
  CA.dist
INTO connections 
FROM ga_medical_centers as h
CROSS JOIN LATERAL (
	SELECT
		id,
		source,
		target,
      	ST_Distance(h.geometry, r.geometry) as dist
    FROM ga_roads_updated as r
	WHERE source != target
    ORDER BY ST_Distance(h.geometry, r.geometry)
    LIMIT 3)
AS CA;

-- Remove tables that will no longer be used after creating the graph dataset
DROP TABLE ga_roads;
DROP TABLE ga_roads_noded;