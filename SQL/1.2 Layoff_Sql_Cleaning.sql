Create database world_layoffs;
Use world_layoffs;
Select * from layoffs;

CREATE TABLE layoffs_staging 
LIKE Layoffs;

SELECT * FROM
layoffs_staging;

INSERT layoffs_staging
SELECT * FROM
layoffs;


-- 1. Remove Dupilcates 
SELECT *, row_number() over(partition by company, industry,total_laid_off,percentage_laid_off, `date`) As row_num FROM 
layoffs_staging;

WITH Duplicates_cte AS
( 
SELECT *, row_number() over(partition by company,industry,total_laid_off,percentage_laid_off, `date`, country, funds_raised_millions,stage) As row_num FROM 
layoffs_staging) 
SELECT * from duplicates_cte where row_num > 1;

Select * from layoffs_staging where company ="casper";
CREATE TABLE `layoffs_staging2` (
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


INSERT into layoffs_staging2 ( 
SELECT *, row_number() over(partition by company,industry,total_laid_off,percentage_laid_off, `date`, country, funds_raised_millions,stage) As row_num FROM 
layoffs_staging); 

SELECT * FROM
layoffs_staging2 where row_num > 1;

DELETE from
layoffs_staging2 where row_num > 1;

SELECT * FROM
layoffs_staging2 ;

-- 2. Standardizing Data
SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT Company, TRIM(company) from layoffs_staging2;

Create database world_layoffs;
Use world_layoffs;
Select * from layoffs;

CREATE TABLE layoffs_staging 
LIKE Layoffs;

SELECT * FROM
layoffs_staging;

INSERT layoffs_staging
SELECT * FROM
layoffs;


-- 1. Remove Dupilcates 
SELECT *, row_number() over(partition by company, industry,total_laid_off,percentage_laid_off, `date`) As row_num FROM 
layoffs_staging;

WITH Duplicates_cte AS
( 
SELECT *, row_number() over(partition by company,industry,total_laid_off,percentage_laid_off, `date`, country, funds_raised_millions,stage) As row_num FROM 
layoffs_staging) 
SELECT * from duplicates_cte where row_num > 1;

Select * from layoffs_staging where company ="casper";
CREATE TABLE `layoffs_staging2` (
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


INSERT into layoffs_staging2 ( 
SELECT *, row_number() over(partition by company,industry,total_laid_off,percentage_laid_off, `date`, country, funds_raised_millions,stage) As row_num FROM 
layoffs_staging); 

SELECT * FROM
layoffs_staging2 where row_num > 1;

DELETE from
layoffs_staging2 where row_num > 1;

SELECT * FROM
layoffs_staging2 ;

-- 2. Standardizing Data
SELECT company, TRIM(company)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET Company = TRIM(company);

SELECT distinct industry 
from layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE industry like 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry like 'Crypto%';

SELECT DISTINCT country ,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
Order by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "country%";

SELECT  DISTINCT COUNTRY FROM layoffs_staging2
order by 1 ;

SELECT `DATE`
FROM Layoffs_staging2;

UPDATE Layoffs_staging2
SET `DATE`= str_to_date(`date`, '%m/%d/%Y');

ALTER Table Layoffs_staging2
MODIFY column `Date` DATE ;

-- 3. NULL Values or blank Values
SELECT * From Layoffs_staging2 where percentage_laid_off is null AND total_laid_off is null;

SELECT t1.company ,t1.industry, t2.industry FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 as t2 on t2.Company = t1.company
AND t1.location = t2.location
where t1.industry IS NULL or t1.industry ='';


UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2 
	ON t2.Company = t1.company
SET t1.Industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


SELECT * FROM layoffs_staging2
WHERE total_laid_off IS null
AND Percentage_laid_off IS NULL ;


DELETE FROM Layoffs_staging2 
WHERE total_laid_off IS null
AND Percentage_laid_off IS NULL ;

-- 4. Remove any columns 
ALTER TABLE layoffs_Staging2
DROP COLUMN ROW_NUM;



SELECT * FROM Layoffs_staging2;

