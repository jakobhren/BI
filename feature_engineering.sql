--Clean null data:
update neighborhood_coordinates 
set latitude = 40.612581,
	 longitude = -74.130729
where neighborhood = 'Meiers Corners';


--LIBRARIES:
alter table libraries
add column neighborhood TEXT;

update libraries l
set neighborhood = sub.neighborhood
from(
	select
		l2.name,
		n.neighborhood
	from libraries l2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(l2.latitude - n.latitude) +
			ABS(l2.longitude - n.longitude)
		limit 1
	)n on true
)sub
where l.name =sub.name

---------------------
--CRIME:

ALTER TABLE crime
ALTER COLUMN latitude TYPE double precision
USING latitude::double precision;

ALTER TABLE crime
ALTER COLUMN longitude TYPE double precision
USING longitude::double precision;

alter table crime
add column neighborhood TEXT;

update crime c
set neighborhood = sub.neighborhood

from(
	select
		c2.arrest_key,
		n.neighborhood
	from crime c2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(c2.latitude - n.latitude) +
			ABS(c2.longitude - n.longitude)
		limit 1
	)n on true
)sub
where c.arrest_key =sub.arrest_key
-------------
--PARKS:

alter table parks
add column neighborhood TEXT;

update parks p
set neighborhood = sub.neighborhood

from(
	select
		p2.name,
		n.neighborhood
	from parks p2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(p2.latitude - n.latitude) +
			ABS(p2.longitude - n.longitude)
		limit 1
	)n on true
)sub
where p.name =sub.name

-------------------
--RESTAURANTS:

ALTER TABLE restaurants
ALTER COLUMN latitude TYPE double precision
USING latitude::double precision;

ALTER TABLE restaurants
ALTER COLUMN longitude TYPE double precision
USING longitude::double precision;

alter table restaurants
add column neighborhood TEXT;

update restaurants r
set neighborhood = sub.neighborhood

from(
	select
		r2.rest_id,
		n.neighborhood
	from restaurants r2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(r2.latitude - n.latitude) +
			ABS(r2.longitude - n.longitude)
		limit 1
	)n on true
)sub
where r.rest_id =sub.rest_id
-----------------
--SCHOOLS:

ALTER TABLE schools
ALTER COLUMN latitude TYPE double precision
USING latitude::double precision;

ALTER TABLE schools
ALTER COLUMN longitude TYPE double precision
USING longitude::double precision;

alter table schools
add column neighborhood TEXT;

update schools s
set neighborhood = sub.neighborhood

from(
	select
		s2.school_id,
		n.neighborhood
	from schools s2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(s2.latitude - n.latitude) +
			ABS(s2.longitude - n.longitude)
		limit 1
	)n on true
)sub
where s.school_id =sub.school_id

--------------------
-- SUBWAY STATIONS:

alter table subway_stations
add column neighborhood TEXT;

update subway_stations ss
set neighborhood = sub.neighborhood

from(
	select
		ss2.station_id,
		n.neighborhood
	from subway_stations ss2
	join lateral (
		select n.neighborhood 
		from neighborhood_coordinates n
		order by
			ABS(ss2."Station Latitude" - n.latitude) +
			ABS(ss2."Station Longitude" - n.longitude)
		limit 1
	)n on true
)sub
where ss.station_id =sub.station_id

--------------------
--BRIDGING AIR QUALITY STATISTICS WITH NEIGHBORHOOD COORDINATES:

CREATE TABLE bridge_air_quality_neighborhood (
    neighborhood_name VARCHAR(255) PRIMARY KEY,
    air_quality_name  VARCHAR(255)
);

INSERT INTO bridge_air_quality_neighborhood (neighborhood_name, air_quality_name) VALUES
-- STATEN ISLAND
('Annadale', 'Southern SI'),
('Arden Heights', 'Southern SI'),
('Arrochar', 'South Beach - Tottenville'),
('Bulls Head', 'Willowbrook'),
('Castleton Corners', 'Stapleton - St. George'),
('Clifton', 'Stapleton - St. George'),
('Dongan Hills', 'South Beach - Tottenville'),
('Eltingville', 'Southern SI'),
('Emerson Hill', 'Willowbrook'),
('Graniteville', 'Port Richmond'),
('Grant City', 'South Beach - Tottenville'),
('Grasmere', 'South Beach - Tottenville'),
('Great Kills', 'Tottenville and Great Kills (CD3)'),
('Grymes Hill', 'Stapleton - St. George'),
('Huguenot', 'Southern SI'),
('Lighthouse Hill', 'Southern SI'),
('Mariner''s Harbor', 'Port Richmond'),
('New Brighton', 'Stapleton - St. George'),
('New Dorp', 'South Beach - Tottenville'),
('Oakwood', 'South Beach - Tottenville'),
('Pleasant Plains', 'Southern SI'),
('Port Richmond', 'Port Richmond'),
('Prince''s Bay', 'Southern SI'),
('Richmond Valley', 'Southern SI'),
('Rosebank', 'Stapleton - St. George'),
('Rossville', 'Southern SI'),
('Shore Acres', 'Stapleton - St. George'),
('Silver Lake', 'Willowbrook'),
('South Beach', 'South Beach - Tottenville'),
('St. George', 'Stapleton - St. George'),
('Stapleton', 'Stapleton - St. George'),
('Tottenville', 'Tottenville and Great Kills (CD3)'),
('Tompkinsville', 'Stapleton - St. George'),
('Travis', 'Port Richmond'),
('West Brighton', 'Port Richmond'),
('Westerleigh', 'Port Richmond'),
('Willowbrook', 'Willowbrook'),
('Woodrow', 'Southern SI'),

-- BROOKLYN
('Bath Beach', 'Bensonhurst - Bay Ridge'),
('Bay Ridge', 'Bay Ridge and Dyker Heights (CD10)'),
('Bedford-Stuyvesant', 'Bedford Stuyvesant (CD3)'),
('Bensonhurst', 'Bensonhurst (CD11)'),
('Borough Park', 'Borough Park (CD12)'),
('Brighton Beach', 'Coney Island - Sheepshead Bay'),
('Brooklyn Heights', 'Fort Greene and Brooklyn Heights (CD2)'),
('Brownsville', 'Brownsville (CD16)'),
('Bushwick', 'Bushwick (CD4)'),
('Canarsie', 'Canarsie - Flatlands'),
('Carroll Gardens', 'Park Slope and Carroll Gardens (CD6)'),
('Coney Island', 'Coney Island (CD13)'),
('Crown Heights', 'Crown Heights and Prospect Heights (CD8)'),
('Downtown', 'Downtown - Heights - Slope'),
('DUMBO', 'Downtown - Heights - Slope'),
('Flatbush', 'Flatbush and Midwood (CD14)'),
('Flatlands', 'Flatlands and Canarsie (CD18)'),
('Fort Greene', 'Fort Greene and Brooklyn Heights (CD2)'),
('Gerritsen Beach', 'Sheepshead Bay (CD15)'),
('Gravesend', 'Coney Island - Sheepshead Bay'),
('Greenpoint', 'Greenpoint'),
('Kensington', 'Flatbush and Midwood (CD14)'),
('Manhattan Beach', 'Sheepshead Bay (CD15)'),
('Marine Park', 'Sheepshead Bay (CD15)'),
('Midwood', 'Flatbush and Midwood (CD14)'),
('Mill Basin', 'Canarsie - Flatlands'),
('Park Slope', 'Park Slope and Carroll Gardens (CD6)'),
('Prospect Heights', 'Crown Heights and Prospect Heights (CD8)'),
('Prospect Lefferts Gardens', 'South Crown Heights and Lefferts Gardens (CD9)'),
('Red Hook', 'Downtown - Heights - Slope'),
('Sheepshead Bay', 'Sheepshead Bay (CD15)'),
('Sunset Park', 'Sunset Park (CD7)'),
('Williamsburg', 'Williamsburg - Bushwick'),
('Windsor Terrace', 'Park Slope and Carroll Gardens (CD6)'),

-- MANHATTAN
('Battery Park', 'Financial District (CD1)'),
('Chelsea', 'Chelsea - Clinton'),
('Chinatown', 'Lower East Side and Chinatown (CD3)'),
('East Harlem', 'East Harlem (CD11)'),
('East Village', 'Union Square - Lower East Side'),
('Financial District', 'Financial District (CD1)'),
('Gramercy', 'Gramercy Park - Murray Hill'),
('Greenwich Village', 'Greenwich Village - SoHo'),
('Hamilton Heights', 'Morningside Heights and Hamilton Heights (CD9)'),
('Harlem', 'Central Harlem (CD10)'),
('Hell''s Kitchen', 'Chelsea - Clinton'),
('Hudson Yards', 'Midtown (CD5)'),
('Inwood', 'Washington Heights and Inwood (CD12)'),
('Little Italy', 'Lower East Side and Chinatown (CD3)'),
('Lower East Side', 'Lower East Side and Chinatown (CD3)'),
('Midtown', 'Midtown (CD5)'),
('Morningside Heights', 'Morningside Heights and Hamilton Heights (CD9)'),
('Murray Hill', 'Gramercy Park - Murray Hill'),
('SoHo', 'Greenwich Village - SoHo'),
('Stuyvesant Town', 'Stuyvesant Town and Turtle Bay (CD6)'),
('Tribeca', 'Financial District (CD1)'),
('Turtle Bay', 'Stuyvesant Town and Turtle Bay (CD6)'),
('Upper East Side', 'Upper East Side (CD8)'),
('Upper West Side', 'Upper West Side (CD7)'),
('Washington Heights', 'Washington Heights'),

-- QUEENS
('Astoria', 'Long Island City - Astoria'),
('Bayside', 'Bayside and Little Neck (CD11)'),
('Bellerose', 'Queens Village (CD13)'),
('Corona', 'Elmhurst and Corona (CD4)'),
('Douglaston', 'Bayside and Little Neck (CD11)'),
('Elmhurst', 'Elmhurst and Corona (CD4)'),
('Flushing', 'Flushing and Whitestone (CD7)'),
('Forest Hills', 'Rego Park and Forest Hills (CD6)'),
('Fresh Meadows', 'Fresh Meadows'),
('Hollis', 'Jamaica and Hollis (CD12)'),
('Howard Beach', 'South Ozone Park and Howard Beach (CD10)'),
('Jackson Heights', 'Jackson Heights (CD3)'),
('Jamaica', 'Jamaica'),
('Kew Gardens', 'Kew Gardens and Woodhaven (CD9)'),
('Maspeth', 'Ridgewood and Maspeth (CD5)'),
('Middle Village', 'Ridgewood and Maspeth (CD5)'),
('Ozone Park', 'South Ozone Park and Howard Beach (CD10)'),
('Queens Village', 'Queens Village (CD13)'),
('Rego Park', 'Rego Park and Forest Hills (CD6)'),
('Ridgewood', 'Ridgewood and Maspeth (CD5)'),
('Rockaway Park', 'Rockaways'),
('Sunnyside', 'Woodside and Sunnyside (CD2)'),
('Whitestone', 'Flushing and Whitestone (CD7)'),
('Woodhaven', 'Kew Gardens and Woodhaven (CD9)'),
('Woodside', 'Woodside and Sunnyside (CD2)'),

-- BRONX
('Baychester', 'Williamsbridge and Baychester (CD12)'),
('Belmont', 'Belmont and East Tremont (CD6)'),
('Bronxdale', 'Morris Park and Bronxdale (CD11)'),
('Concourse', 'Highbridge and Concourse (CD4)'),
('East Tremont', 'Belmont and East Tremont (CD6)'),
('Fordham', 'Fordham and University Heights (CD5)'),
('Highbridge', 'Highbridge and Concourse (CD4)'),
('Kingsbridge', 'Kingsbridge - Riverdale'),
('Longwood', 'Hunts Point and Longwood (CD2)'),
('Melrose', 'Mott Haven and Melrose (CD1)'),
('Morris Park', 'Morris Park and Bronxdale (CD11)'),
('Mott Haven', 'Mott Haven and Melrose (CD1)'),
('Parkchester', 'Parkchester and Soundview (CD9)'),
('Riverdale', 'Riverdale and Fieldston (CD8)'),
('Soundview', 'Parkchester and Soundview (CD9)'),
('Throggs Neck', 'Throgs Neck and Co-op City (CD10)'),
('Williamsbridge', 'Williamsbridge and Baychester (CD12)');