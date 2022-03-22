/* 1. GLOBAL SITUATION */


/* a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.*/

SELECT forest_area_sqkm
FROM forest_area
WHERE year = 1990
AND country_name = 'World'


SELECT *
FROM forest_area
WHERE country_name = 'World'
AND (year = 2016 OR year = 1990);

 /* b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”*/

SELECT forest_area_sqkm
FROM forest_area
WHERE country_name = 'World'
AND year = 2016 ;

 /* c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */

SELECT oldest_forest_area.forest_area_sqkm  - latest_forest_area.forest_area_sqkm 
AS difference
FROM forest_area AS latest_forest_area
JOIN forest_area AS oldest_forest_area
  ON  (latest_forest_area.year = '2016' AND oldest_forest_area.year = '1990'
  AND latest_forest_area.country_name = 'World' AND oldest_forest_area.country_name = 'World');

 /* d. What was the percent change in forest area of the world between 1990 and 2016?*/

SELECT 100.0* (oldest_forest_area.forest_area_sqkm  - latest_forest_area.forest_area_sqkm)/oldest_forest_area.forest_area_sqkm 
AS percent
FROM forest_area AS latest_forest_area
JOIN forest_area AS oldest_forest_area
  ON  (latest_forest_area.year = '2016' AND oldest_forest_area.year = '1990'
  AND latest_forest_area.country_name = 'World' AND oldest_forest_area.country_name = 'World');

 /* e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?*/

SELECT country_name, (total_area_sq_mi * 2.59) AS total_area_sqkm
FROM land_area
WHERE year = 2016
AND (total_area_sq_mi * 2.59) < 1324449
ORDER BY total_area_sqkm DESC;

/* 2. REGIONAL OUTLOOK  */

DROP VIEW IF EXISTS region_to_forest;
/* 2. Making New Table
Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
Based on the table you created, ....  */

CREATE VIEW region_to_forest AS
SELECT f.country_name, f.year, f.forest_area_sqkm,
l.total_area_sq_mi, r.region, r.income_group
FROM forest_area f, land_area l, regions r
WHERE (f.country_name = l.country_name
AND f.country_name = r.country_name);

SELECT * FROM region_to_forest;
/* 2.2. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?  */
SELECT Round(100.0*(rf.forest_area_sqkm / 
  (rf.total_area_sq_mi * 2.59))::Numeric, 2) AS percentage
FROM region_to_forest rf
WHERE year = 2016
AND rf.country_name = 'World'
LIMIT 1;

SELECT region,
 Round(((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
percent_forest
FROM region_to_forest
WHERE YEAR = 2016
GROUP BY region
ORDER BY percent_forest DESC

/* 2. b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?  */

SELECT Round(100.0*(rf.forest_area_sqkm / 
  (rf.total_area_sq_mi * 2.59))::Numeric, 2) AS percentage
FROM region_to_forest rf
WHERE year = 1990
AND rf.country_name = 'World'
LIMIT 1;

SELECT region,
 Round(((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
percent_forest
FROM region_to_forest
WHERE YEAR = 1990
GROUP BY region
ORDER BY percent_forest DESC


/* 2. c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?  */

SELECT ROUND(CAST((region_forest_1990/ region_area_1990) * 100 AS NUMERIC), 2) 
  AS forest_percent_1990,
  ROUND(CAST((region_forest_2016 / region_area_2016) * 100 AS NUMERIC), 2) 
  AS forest_percent_2016,
  region  
FROM (SELECT SUM(a.forest_area_sqkm) region_forest_1990,
  SUM(a.total_area_sq_mi * 2.59) region_area_1990, a.region,
  SUM(b.forest_area_sqkm) region_forest_2016,
  SUM(b.total_area_sq_mi * 2.59)  region_area_2016
FROM  region_to_forest a, region_to_forest b
WHERE  a.year = '1990'
AND a.country_name != 'World'
AND b.year = '2016'
AND b.country_name != 'World'
AND a.region = b.region
GROUP  BY a.region) region_percent 
ORDER  BY forest_percent_1990 DESC;