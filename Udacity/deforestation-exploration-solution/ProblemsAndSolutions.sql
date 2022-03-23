
DROP VIEW IF EXISTS Forestation;
/* 2. Making New Table
Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
Based on the table you created, ....  */

CREATE VIEW Forestation AS
SELECT r.country_name,
 f.year,
 r.income_group,
 r.region,
 l.total_area_sq_mi,
 f.forest_area_sqkm,
 ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) percentage_forest
FROM forest_area f
JOIN land_area l ON f.country_code = l.country_code
AND f.year = l.year
JOIN regions r ON r.country_code = f.country_code
GROUP BY r.country_name,
 f.year,
 r.income_group,
 r.region,
 l.total_area_sq_mi,
 f.forest_area_sqkm

/* 1. GLOBAL SITUATION */
/* a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.*/

SELECT forest_area_sqkm
FROM Forestation 
WHERE year = 1990
AND country_name = 'World'


SELECT *
FROM Forestation 
WHERE country_name = 'World'
AND (year = 2016 OR year = 1990);

 /* b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”*/

SELECT forest_area_sqkm
FROM Forestation 
WHERE country_name = 'World'
AND year = 2016 ;

 /* c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */

SELECT oldest_forest_area.forest_area_sqkm  - latest_forest_area.forest_area_sqkm 
AS difference
FROM Forestation AS latest_forest_area
JOIN Forestation AS oldest_forest_area
  ON  (latest_forest_area.year = '2016' AND oldest_forest_area.year = '1990'
  AND latest_forest_area.country_name = 'World' AND oldest_forest_area.country_name = 'World');

 /* d. What was the percent change in forest area of the world between 1990 and 2016?*/

SELECT 100.0* (oldest_forest_area.forest_area_sqkm  - latest_forest_area.forest_area_sqkm)/oldest_forest_area.forest_area_sqkm 
AS percent
FROM Forestation AS latest_forest_area
JOIN Forestation AS oldest_forest_area
  ON  (latest_forest_area.year = '2016' AND oldest_forest_area.year = '1990'
  AND latest_forest_area.country_name = 'World' AND oldest_forest_area.country_name = 'World');

 /* e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?*/

SELECT country_name, (total_area_sq_mi * 2.59) AS total_area_sqkm
FROM Forestation 
WHERE year = 2016
AND (total_area_sq_mi * 2.59) < 1324449
ORDER BY total_area_sqkm DESC;

/* 2. REGIONAL OUTLOOK  */

/* 2.2. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?  */
SELECT Round(100.0*(rf.forest_area_sqkm / 
  (rf.total_area_sq_mi * 2.59))::Numeric, 2) AS percentage
FROM Forestation rf
WHERE year = 2016
AND rf.country_name = 'World'
LIMIT 1;

SELECT region,
 Round(((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
percent_forest
FROM Forestation
WHERE YEAR = 2016
GROUP BY region
ORDER BY percent_forest DESC

/* 2. b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?  */

SELECT Round(100.0*(rf.forest_area_sqkm / 
  (rf.total_area_sq_mi * 2.59))::Numeric, 2) AS percentage
FROM Forestation rf
WHERE year = 1990
AND rf.country_name = 'World'
LIMIT 1;

SELECT region,
 Round(((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
percent_forest
FROM Forestation
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
FROM  Forestation a, Forestation b
WHERE  a.year = '1990'
AND a.country_name != 'World'
AND b.year = '2016'
AND b.country_name != 'World'
AND a.region = b.region
GROUP  BY a.region) region_percent 
ORDER  BY forest_percent_1990 DESC;

/* 3. COUNTRY-LEVEL DETAIL  */

/* 3. a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?  */
WITH T1 AS
 (SELECT country_name,
 forest_area_sqkm fa_1
 FROM Forestation
 WHERE YEAR = 1990
 GROUP BY country_name,
 forest_area_sqkm),
 T2 AS
 (SELECT country_name,
 (forest_area_sqkm) fa_2
 FROM Forestation
 WHERE YEAR = 2016
 GROUP BY country_name,
 forest_area_sqkm)
 SELECT f_prev.country_name,
 (f_prev.fa_1 - f_curr.fa_2) forest_change
FROM T1 f_prev
JOIN T2 f_curr ON f_prev.country_name = f_curr.country_name
ORDER BY forest_change
LIMIT 1

WITH T1 AS
 (SELECT country_name, region,
 SUM(forest_area_sqkm) forest_area_1
 FROM Forestation
 WHERE YEAR = 1990
 GROUP BY country_name,
 forest_area_sqkm, region),
 T2 AS
 (SELECT country_name,
 SUM(forest_area_sqkm) forest_area_2
 FROM Forestation
 WHERE YEAR = 2016
 GROUP BY country_name,
 forest_area_sqkm)
SELECT f.country_name, f.region,
 (f.forest_area_1 - t.forest_area_2) forest_change
FROM T1 f
JOIN T2 t ON f.country_name = t.country_name
WHERE f.forest_area_1 IS NOT NULL
 AND t.forest_area_2 IS NOT NULL
 AND f.country_name != 'World'
ORDER BY forest_change DESC
LIMIT 5


SELECT curr.country_name, curr.region,
  curr.forest_area_sqkm - prev.forest_area_sqkm AS difference
FROM Forestation AS curr
JOIN Forestation AS prev
  ON  (curr.year = '2016' AND prev.year = '1990')
  AND curr.country_name = prev.country_name  
 WHERE curr.country_name != 'World'
ORDER BY difference
LIMIT 5



/* b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?  */

WITH T1 AS
 (SELECT country_name,
 (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 fp_1
 FROM Forestation
 WHERE YEAR = 1990
 GROUP BY country_name,
 forest_area_sqkm),
 T2 AS
 (SELECT country_name,
 (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 fp_2
 FROM Forestation
 WHERE YEAR = 2016
 GROUP BY country_name,
 forest_area_sqkm)
 SELECT f_prev.country_name,
 Round((((f_prev.fp_1 -
f_curr.fp_2)/(f_prev.fp_1))*100)::Numeric, 2) percent_change
FROM T1 f_prev
JOIN T2 f_curr ON f_prev.country_name = f_curr.country_name
ORDER BY percent_change
LIMIT 5


SELECT curr.country_name, curr.region
  100.0*(curr.forest_area_sqkm - prev.forest_area_sqkm) / 
  prev.forest_area_sqkm AS percentage
FROM Forestation AS curr
JOIN Forestation AS prev
  ON  (curr.year = '2016' AND prev.year = '1990')
  AND curr.country_name = prev.country_name
ORDER BY percentage;
/* c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?  */
WITH T1 AS
 (SELECT country_name, year,
 (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 percent_forestation
 FROM Forestation
 WHERE YEAR = 2016
 GROUP BY country_name,
 year,
 forest_area_sqkm)
 SELECT Distinct(quartiles),
 count(country_name)Over(PARTITION BY quartiles)
  FROM
 (SELECT country_name,
 CASE
 WHEN percent_forestation<25 THEN '0-25'
 WHEN percent_forestation>=25
 AND percent_forestation<50 THEN '25-50'
 WHEN percent_forestation>=50
 AND percent_forestation<75 THEN '50-75'
 ELSE '75-100'
 END AS quartiles
 FROM T1
 WHERE percent_forestation IS NOT NULL
 AND YEAR = 2016) sub

/* d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.  */
WITH T2 AS
 (WITH T1 AS
 (SELECT country_name,
 YEAR,
 (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 percent_forestation
 FROM Forestation forestation
 WHERE YEAR = 2016
 GROUP BY country_name,
 YEAR,
 forest_area_sqkm) SELECT Distinct(quartiles),
 count(country_name)Over(PARTITION BY quartiles),
 country_name,
 percent_forestation
 FROM
 (SELECT country_name,
 percent_forestation,
 CASE
 WHEN percent_forestation<=25 THEN '0-25'
 WHEN percent_forestation>25
 AND percent_forestation<=50 THEN '25-50'
 WHEN percent_forestation>50
 AND percent_forestation<=75 THEN '50-75'
 ELSE '75-100'
 END AS quartiles
 FROM T1
 WHERE percent_forestation IS NOT NULL
 AND YEAR = 2016) sub)
SELECT country_name,
 quartiles,
 Round(percent_forestation::Numeric, 2) percent_forestation
FROM T2
WHERE quartiles = '75-100'
ORDER BY percent_forestation DESC


/* e. How many countries had a percent forestation higher than the United States in 2016?  */

SELECT COUNT(percentage_forest)
FROM forestation
WHERE percentage_forest > 75 AND year = 2016
