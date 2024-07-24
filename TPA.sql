CREATE TABLE bokoharam(
	event_id_cnty varchar,
	event_date varchar,
	years int,
	time_precision int,
	disorder_type varchar,
	event_type varchar,
	sub_event_type varchar,
	actor1 varchar,
	assoc_actor_1 varchar,
	inter1 int,
	actor2 varchar,
	assoc_actor_2 varchar,
	inter2 int,
	interaction int,
	civilian_targeting varchar,
	iso int,
	region varchar,
	country varchar,
	admin1 varchar,
	admin2 varchar,
	admin3 varchar,
	locations varchar,
	latitude numeric,
	longitude numeric,
	geo_precision int,
	sources varchar,
	source_scale varchar,
	notes varchar,
	fatalities int,
	tags varchar,
	timestamps int);

CREATE TABLE iswap(
	event_id_cnty varchar,
	event_date varchar,
	years int,
	time_precision int,
	disorder_type varchar,
	event_type varchar,
	sub_event_type varchar,
	actor1 varchar,
	assoc_actor_1 varchar,
	inter1 int,
	actor2 varchar,
	assoc_actor_2 varchar,
	inter2 int,
	interaction int,
	civilian_targeting varchar,
	iso int,
	region varchar,
	country varchar,
	admin1 varchar,
	admin2 varchar,
	admin3 varchar,
	locations varchar,
	latitude numeric,
	longitude numeric,
	geo_precision int,
	sources varchar,
	source_scale varchar,
	notes varchar,
	fatalities int,
	tags varchar,
	timestamps int);

--Select the data for the first analysis - Boko Haram Data
SELECT actor1 AS group_name, event_id_cnty, event_date, sub_event_type, admin1, actor1, locations, fatalities
FROM bokoharam
ORDER BY 1,2

--Select the data for the first analysis - ISWAP Data
SELECT actor1 AS group_name, event_id_cnty, event_date, sub_event_type, admin1, actor1, locations, fatalities
FROM iswap
ORDER BY 1,2 

--Total number of incidents	- Boko Haram Data
SELECT 'Boko Haram' AS group_name, 
COUNT(*) AS total_incidents 
FROM bokoharam

--Total number of incidents	- ISWAP Data
SELECT 'ISWAP' AS group_name, 
COUNT(*) AS total_incidents 
FROM iswap

--Comparing the activities of different groups - Boko Haram Data
SELECT 
    actor1 AS group_name,
    sub_event_type AS incident_type,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities
FROM 
    bokoharam
WHERE 
    actor1 IN ('Boko Haram - Jamaatu Ahli is-Sunnah lid-Dawati wal-Jihad', 
               'Islamic State (West Africa)', 
               'Military Forces of Nigeria (2023-)')
GROUP BY 
     actor1, incident_type
ORDER BY 
    actor1, incident_count DESC;

--Comparing the activities of different groups - ISWAP Data
SELECT 
    actor1 AS group_name,
    sub_event_type AS incident_type,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities
FROM 
    iswap
WHERE 
    actor1 IN ('Islamic State (West Africa) and/or Boko Haram - Jamaatu Ahli is-Sunnah lid-Dawati wal-Jihad','Gujba Communal Militia (Nigeria)', 'Konduga Communal Militia (Nigeria)', 
               'Military Forces of Nigeria (2023-)')
GROUP BY 
     actor1, incident_type
ORDER BY 
    actor1, incident_count DESC;

--Examining the distribution of fatalities across different sub-event types and actors - Boko Haram Data
SELECT 
    sub_event_type AS sub_incident_type,
    actor1 AS group_name,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities,
    ROUND (AVG(fatalities)) AS avg_fatalities_per_incident
FROM 
	bokoharam
GROUP BY 
  sub_event_type, actor1
ORDER BY 
    total_fatalities DESC;

--Examining the distribution of fatalities across different sub-event types and actors - ISWAP Data
SELECT 
    sub_event_type AS sub_incident_type,
    actor1 AS group_name,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities,
    ROUND (AVG(fatalities)) AS avg_fatalities_per_incident
FROM 
	iswap
GROUP BY 
   actor1, sub_event_type
ORDER BY 
    total_fatalities DESC;

--Analyzing how the frequency and intensity of events have changed over the six-month period - Boko Haram Data
SELECT 
    TO_CHAR (DATE_TRUNC('month', event_date::date), 'Month') AS month,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities,
    ROUND (AVG(fatalities)) AS avg_fatalities_per_incident,
    STRING_AGG(DISTINCT admin1, ',') AS affected_states
FROM 
    bokoharam
GROUP BY 
    DATE_TRUNC('month', event_date::date)
ORDER BY 
    DATE_TRUNC('month', event_date::date);

--Analyzing how the frequency and intensity of events have changed over the six-month period - ISWAP Data
SELECT 
    TO_CHAR (DATE_TRUNC('month', event_date::date), 'Month') AS month,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities,
    ROUND (AVG(fatalities)) AS avg_fatalities_per_incident,
    STRING_AGG(DISTINCT admin1, ',') AS affected_states
FROM 
    bokoharam
GROUP BY 
    DATE_TRUNC('month', event_date::date)
ORDER BY 
    DATE_TRUNC('month', event_date::date);

--Evolving Tactics - Boko Haram Data
SELECT sub_event_type, COUNT(*) AS occurrence_count,
     SUM(fatalities) AS total_fatalities
FROM iswap
WHERE actor1 LIKE '%Boko Haram%' OR actor2 LIKE '%Boko Haram%'
GROUP BY sub_event_type
ORDER BY occurrence_count DESC;

--Evolving Tactics - ISWAP Data
SELECT sub_event_type, COUNT(*) AS occurrence_count,
SUM(fatalities) AS total_fatalities
FROM iswap
WHERE actor1 LIKE '%Boko Haram%' OR actor2 LIKE '%Boko Haram%'
GROUP BY sub_event_type
ORDER BY occurrence_count DESC;

--Most Affected State/ Local Government / Ward - Boko Haram Data
SELECT
    admin1 AS states, admin2 AS local_government,
    locations AS wards,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities
FROM
    bokoharam
GROUP BY
    admin1,
    admin2,
	locations
ORDER BY
    total_fatalities DESC
LIMIT 5;

--Most Affected State/ Local Government / Ward - ISWAP Data
SELECT
    admin1 AS states, admin2 AS local_government,
    locations AS wards,
    COUNT(*) AS incident_count,
    SUM(fatalities) AS total_fatalities
FROM
    iswap
GROUP BY
    admin1,
    admin2,
	locations
ORDER BY
    total_fatalities DESC
LIMIT 5
