-- Duplicate data
select*
from layoffs;

create table layoffs_staging
like layoffs;

insert into layoffs_staging
select*
from layoffs;

select*
from layoffs_staging;

select*,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions) row_num
from layoffs_staging;

with cte as (
select*,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions) row_num
from layoffs_staging
)
select*
from cte
where row_num > 1;

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
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select*,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions) row_num
from layoffs_staging;

delete
from layoffs_staging2
where row_num > 1;

alter table layoffs_staging2
drop column row_num;

truncate layoffs_staging;

insert into layoffs_staging
select*
from layoffs_staging2;

drop table layoffs_staging2;

-- Standardize Data
select distinct company
from layoffs_staging;

update layoffs_staging
set company = trim(company);

select distinct location
from layoffs_staging
order by 1;

select distinct industry
from layoffs_staging
order by 1;

select*
from layoffs_staging
where industry like 'crypto%';

update layoffs_staging
set industry = 'Crypto'
where industry like 'crypto%';

select date, str_to_date(date,'%m/%d/%Y') date
from layoffs_staging;

update layoffs_staging
set date = str_to_date(date, '%m/%d/%Y');

select distinct stage
from layoffs_staging
order by 1;

select distinct country, trim(trailing '.' from country) country
from layoffs_staging
order by 1;

update layoffs_staging
set country = trim(trailing '.' from country);

select*
from layoffs_staging;

-- Null Value and Blank Value
select*
from layoffs_staging
where company is null or company = '';

select*
from layoffs_staging
where location is null or location ='';

select*
from layoffs_staging
where industry is null or industry ='';

update layoffs_staging
set industry = null
where industry = '';

select t1.company, t1.industry, t2.industry
from layoffs_staging t1
join layoffs_staging t2
		on t1.company = t2.company
        and t1.location = t2.location
where t1.industry is null and t2.industry is not null;

update layoffs_staging t1
join layoffs_staging t2
		on t1.company = t2.company
        and t1.location = t2.location
set t1.industry = t2.industry
where  t1.industry is null and t2.industry is not null;

delete
from layoffs_staging
where total_laid_off is null and percentage_laid_off is null;

select*
from layoffs_staging
where stage is null or stage = '';

select *
from layoffs_staging t1
join layoffs_staging t2
		on t1.company = t2.company
        and t1.location = t2.location
        and t1.industry = t2.industry
where (t1.stage is null or t1.stage = '') and t2.stage is not null;
        
select*
from layoffs_staging
where country is null or country = '';