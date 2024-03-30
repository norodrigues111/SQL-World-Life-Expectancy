# World Life Expectancy Project - Data Cleaning

USE world_life_expectancy;

SELECT * FROM world_life_expectancy;

# Duplicates
/* This query aims to ensure that the life expectancy data 
   only includes one row per country and per specific year. 
   We achieve this by aggregating the data using the MAX function
   to select the maximum life expectancy value for each country-year combination.
*/

# Identifying duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_Table
WHERE Row_Num > 1; 

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
	WHERE Row_Num > 1);
 
 
# Handling Missing Values - Status
SELECT * FROM world_life_expectancy
WHERE Status = '';

SELECT DISTINCT(Status) FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT(Country) FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	USING (Country)
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

# Handling Missing Values - Life expectancy
SELECT * FROM world_life_expectancy
WHERE `Life expectancy`= '';

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE Country IN ('Afghanistan','Albania');

/*
It is evident that the life expectancy of Afghanistan and Albania is consistently increasing
over time. Therefore, to address the null values, we can consider utilizing 
the median value between the preceding and succeeding life expectancy values.
*/

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
	t2.Country, t2.Year, t2.`Life expectancy`,
    t3.Country, t3.Year, t3.`Life expectancy`,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
     AND t1.Year = t3.Year +1
WHERE t1.`Life expectancy`= '';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
     AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy`= '';

