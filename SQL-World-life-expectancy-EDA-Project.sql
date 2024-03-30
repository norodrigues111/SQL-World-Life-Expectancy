# World Life Expectancy EDA Exploratory Data Analysis

USE world_life_expenctancy;

SELECT * FROM world_life_expectancy;

# Explore Life Expectancy
SELECT MIN(`Life expectancy`), MAX(`Life expectancy`) 
FROM world_life_expectancy;

/* Here's a rewritten version:
Analysis of the minimum and maximum life expectancies, along with the respective 
increase for each country over the last 15 years.
*/

SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`)-MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC;

# Global Life Expectancy
SELECT Year, ROUND(AVG(`Life expectancy`),2) AS Global_Life_Expenctancy
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year DESC;

# Correlation between Life Expectancy and other attributes

# Correlation between Life Expectancy VS GDP
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Lif_Exp_AVG, 
ROUND(AVG(GDP),1) AS GDP_AVG
FROM world_life_expectancy
GROUP BY Country
HAVING Lif_Exp_AVG > 0
AND GDP_AVG > 0
ORDER BY GDP_AVG ASC;

# Insert Categories to investigate the correlation between Life Expectancy VS GDP
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),2) AS High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),2) AS Low_GDP_Life_expectancy
FROM world_life_expectancy;

# Correlation between Life Expectancy VS Status
SELECT Status, ROUND(AVG(`Life expectancy`),1) AS GDP_AVG
FROM world_life_expectancy
GROUP BY Status;

# Check the amount of Country By Status
SELECT Status, 
	ROUND(AVG(`Life expectancy`),1) AS GDP_AVG, 
	COUNT(DISTINCT Country) AS Qtd_Country_ByStatus
FROM world_life_expectancy
GROUP BY Status;

# Correlation between Life Expectancy VS BMI
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Lif_Exp_AVG, 
ROUND(AVG(BMI),1) AS BMI_AVG
FROM world_life_expectancy
GROUP BY Country
HAVING Lif_Exp_AVG > 0
AND BMI_AVG > 0
ORDER BY BMI_AVG DESC;

SELECT * FROM world_life_expectancy;

# Calculation of adult mortality using a rolling total.
SELECT Country, 
Year, 
`Life expectancy`,
`Adult Mortality`, 
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE 'IRELAND';