-- Data Exploratory Analysis

USE world_layoffs;

SELECT * 
FROM layoff_staging_2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoff_staging_2;

SELECT *
FROM layoff_staging_2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoff_staging_2;

SELECT industry,SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country,SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage,SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company,SUM(percentage_laid_off)
FROM layoff_staging_2
GROUP BY company
ORDER BY 2 DESC;
-- rolling sum of layoffs
SELECT SUBSTRING(`date`,1,7) AS `month`,SUM(total_laid_off)
FROM layoff_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `month`,SUM(total_laid_off) AS total_off
FROM layoff_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`,total_off,SUM(total_off)OVER(ORDER BY `month`) as rolling_total
FROM Rolling_Total;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year AS
(
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoff_staging_2
GROUP BY company,YEAR(`date`)
)
SELECT *
FROM  company_year;



