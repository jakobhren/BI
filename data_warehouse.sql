-- DATA WAREHOUSE (STAR SCHEMA):

-- DIM TABLES:

CREATE VIEW dim_crime AS
SELECT 
    neighborhood,
    COUNT(*) AS crime_count,
    COUNT(DISTINCT ofns_desc) AS distinct_offence_count
FROM crime
GROUP BY neighborhood;

CREATE VIEW dim_libraries AS
SELECT 
    neighborhood,
    COUNT(*) AS library_count
FROM libraries
GROUP BY neighborhood;

CREATE VIEW dim_schools AS
SELECT 
    neighborhood,
    COUNT(*) AS school_count,
    COUNT(DISTINCT location_category_description) AS school_type_count
FROM schools
GROUP BY neighborhood;

CREATE VIEW dim_restaurants AS
SELECT 
    neighborhood,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY neighborhood;

CREATE VIEW dim_parks AS
SELECT 
    neighborhood,
    COUNT(*) AS park_count,
    COUNT(DISTINCT typecategory) AS park_type_count
FROM parks
GROUP BY neighborhood;

CREATE VIEW dim_subway AS
SELECT 
    neighborhood,
    COUNT(DISTINCT station_id) AS station_count,
    SUM("EntranceCount") AS total_entrances,
    SUM("RouteCount") AS total_routes
FROM subway_stations
GROUP BY neighborhood;

CREATE VIEW dim_air_quality AS
SELECT 
    b.neighborhood_name AS neighborhood,
    AVG("Fine particles (PM 2.5)") AS avg_fine_particles,
    AVG("Nitrogen dioxide (NO2)") AS avg_no2
FROM air_quality a
JOIN bridge_air_quality_neighborhood b
    ON a.geo_place_name = b.air_quality_name
GROUP BY b.neighborhood_name;

CREATE VIEW dim_clusters AS
SELECT
	neighborhood,
	"cluster"
FROM clusters;
	
--FACT TABLE:

CREATE VIEW fact_neighborhood_price_analysis AS
SELECT 
    p."RegionName" AS neighborhood,
    p."2025_mean" AS price_2025,
  	-- coalesce to replace NULL values with 0 where the counts amount to 0
	COALESCE(c.crime_count, 0) AS crime_count,
    COALESCE(c.distinct_offence_count, 0) AS distinct_offence_count,
	COALESCE(l.library_count, 0) AS library_count,
    COALESCE(s.school_count, 0) AS school_count,
    COALESCE(s.school_type_count, 0) AS school_type_count,
    COALESCE(r.restaurant_count, 0) AS restaurant_count,
    COALESCE(pa.park_count, 0) AS park_count,
    COALESCE(pa.park_type_count, 0) AS park_type_count,
    COALESCE(su.station_count, 0) AS station_count,
    COALESCE(su.total_entrances, 0) AS total_entrances,
    COALESCE(su.total_routes, 0) AS total_routes,
	-- keep these as NULL, as it would be misleading to chnange it to 0.
    COALESCE(aq.avg_fine_particles, NULL ) AS avg_fine_particles,
    COALESCE(aq.avg_no2, NULL) AS avg_no2
FROM nyc_neighborhood_prices p
LEFT JOIN dim_crime c ON c.neighborhood = p."RegionName"
LEFT JOIN dim_libraries l ON l.neighborhood = p."RegionName"
LEFT JOIN dim_schools s ON s.neighborhood = p."RegionName"
LEFT JOIN dim_restaurants r ON r.neighborhood = p."RegionName"
LEFT JOIN dim_parks pa ON pa.neighborhood = p."RegionName"
LEFT JOIN dim_subway su ON su.neighborhood = p."RegionName"
LEFT JOIN dim_air_quality aq ON aq.neighborhood = p."RegionName";
