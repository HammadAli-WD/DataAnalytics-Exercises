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