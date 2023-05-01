
-- Create table containing a sample address geocoded for purposes of testing integration and shortest path function.
-- Example address is CS faculty building at 25 Park Place, Atlanta, GA 30303, Address given must be normalized
CREATE TABLE geocoded(
address text,
longitude double precision,
latitude double precision,
geom geometry
);
INSERT INTO geocoded VALUES (
	'25 PARK PL, ATLANTA, GA 30303', 
	-84.38779, 
	33.75508, 
	ST_Point(-84.38779, 33.75508, 4326)
);
-- You can add other addresses after finding their geocoded location online if you wish to try another location

-- Ensure geocoded table just created's SRID is same as other datasets within database - our current is 4326
-- This SRID can be changed to any other SRID or projection of your preference for purposes of your application
ALTER TABLE geocoded ADD geom_2 geometry;
UPDATE geocoded set geom_2 = ST_Transform(geom, 4326);
SELECT UpdateGeometrySRID('public', 'geocoded', 'geom_2', 4326);
ALTER TABLE geocoded DROP COLUMN geom;
ALTER TABLE geocoded RENAME COLUMN geom_2 TO geom;

-- Find closest roads to geocoded address and save into table "roads_and_hospitals"
DROP TABLE roads_and_hospitals;
SELECT 
	gc.address,
	ch.objectid as closest_hospital,
	ch.dist as dist_to_hosp,
	cr.rid as road_to_address,
	cr.sr as r_source,
	cr.tg as r_target,
	cr.dist2 as dist_to_road,
	cr.geometry as r_geometry
INTO roads_and_hospitals
FROM (
	-- Finding 3 closest hospitals to given geocoded address via nearest neighbor
	SELECT * , h.geometry <-> g.geom AS dist
	-- INTO closest_hospitals
	FROM ga_medical_centers h, geocoded_address as g
	ORDER BY dist
	LIMIT 3
) as ch, geocoded_address as gc
-- Join each result of closest edge into one table output called "geocode_to_roads_and_hospitals"
CROSS JOIN LATERAL (
	SELECT 
		r.id as rid,
		r.source as sr,
		r.target as tg,
      	ST_Distance(gc.geom, r.geometry) as dist2,
		r.geometry
      	FROM ga_roads_updated as r
		WHERE r.source != r.target
      	ORDER BY dist2
     	LIMIT 3)
AS cr;

-- SAVE SELECTED HOSPITAL AS THE CLOSEST FOR DEMONSTRATION PURPOSES
SELECT h.*
INTO closest_hospital
FROM ga_medical_centers as h
INNER JOIN roads_and_hospitals as rh
ON h.objectid = rh.closest_hospital
ORDER BY dist_to_hosp
LIMIT 1;

-- TEST DIJKSTRA WITH NODES FROM SCHOOL TO GRADY HOSPITAL
-- Use dijkstra function from pg routing to calculate shortest path for testing purposes
-- seq is int, path_seq = int, node = bigint, edge = bigint, cost = double pres, agg_cost = double pres
DROP TABLE road_path; -- This in case you wish to run this query with a different address for testing purposes, deletes old table
SELECT seq, edge, node, geometry
INTO road_path
FROM pgr_dijkstra(
	'SELECT id, source, target, cost, cost FROM ga_roads_updated',
	-- Extract start node near geocoded address from table roads_and_hospitals
	 (	SELECT rh.r_target
		FROM roads_and_hospitals as rh
		ORDER BY rh.dist_to_road
		LIMIT 1
	 ), 
	-- Extract end node near hospital closest to geocoded address from table "connections"
	 (	SELECT c.target
		FROM connections as c, roads_and_hospitals as rh
	  	WHERE c.hospitalid = rh.closest_hospital
		ORDER BY rh.dist_to_hosp
		LIMIT 1
	 ),  
	 false)
as paths
JOIN ga_roads_updated edges ON paths.edge = edges.id;