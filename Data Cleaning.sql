-- Data Cleaning
use world_layoffs;
SELECT * from layoffs;

-- 1. Remoove Duplicates
-- 2. Standardize the data
-- 3. NUll values or blank values
-- 4. Remove any columns

CREATE TABLE layoff_staging
LIKE layoffs;

INSERT layoff_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoff_staging;
-- Removing Duplicates
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT * FROM duplicate_cte
WHERE row_num>1;


CREATE TABLE `layoff_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging_2;
INSERT INTO layoff_staging_2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_staging;
DELETE 
FROM layoff_staging_2
WHERE row_num>1;
SELECT *
FROM layoff_staging_2;
-- Standardizing the Data
		-- Removing the unwanted spaces using trim
UPDATE layoff_staging_2
SET company=trim(company);
SELECT DISTINCT industry 
FROM layoff_staging_2
ORDER BY 1;
		-- Standardizing the names
UPDATE layoff_staging_2
SET industry='Crypto'
WHERE industry LIKE 'Crypt0%';
		-- changing date datatype
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoff_staging_2;
UPDATE layoff_staging_2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');
		-- Yet datatype not changes so.
ALTER TABLE layoff_staging_2
MODIFY COLUMN `date` DATE;

-- Null Values and Blank Values

UPDATE layoff_staging_2
SET industry = NULL
WHERE industry ='';

SELECT *
FROM layoff_staging_2 t1
JOIN layoff_staging_2 t2
ON t1.company=t2.company
AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoff_staging_2 t1
JOIN layoff_staging_2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Removing Columns AND Rows

SELECT *
FROM layoff_staging_2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging_2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

ALTER TABLE layoff_staging_2 
DROP COLUMN row_num;

SELECT *
FROM layoff_staging_2;












