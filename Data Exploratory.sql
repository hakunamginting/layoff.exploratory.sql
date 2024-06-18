select*
from layoffs_staging;

-- Comparing company to total_laid_off
select company, sum(total_laid_off) total_laid_off
from layoffs_staging
group by company
order by 2 desc;

-- Comparing location to total_laid_off
select location, sum(total_laid_off) total_laid_off
from layoffs_staging
group by location
order by 2 desc;

-- Find out what country got the most total_laid_off
select country, sum(total_laid_off) total_laid_off
from layoffs_staging
group by country
order by 2 desc
limit 1;

-- Find Out what company got the most total_laid_off in the 2020, 2021, 2022, 2023
select company, year(date) years, sum(total_laid_off) total_laid_off
from layoffs_staging
group by company, years;

with cte as (
select company, year(date) years, sum(total_laid_off) total_laid_off
from layoffs_staging
group by company, years
)
select*,
dense_rank() over(partition by years order by total_laid_off desc) ranking
from cte
where years is not null
order by 4
limit 4;

-- Now, when we know company who got the most laid off, let's find out which country who got the most laid off in 2020, 2021, 2022, 2023
select country, year(date) years, sum(total_laid_off) total_laid_off
from layoffs_staging
group by country, years;

with cte as (
select country, year(date) years, sum(total_laid_off) total_laid_off
from layoffs_staging
group by country, years
)
select*,
dense_rank() over(partition by years order by total_laid_off desc) ranking
from cte
where years is not null
order by 4,2
limit 4;

-- When the laid off date start and end
select min(date) Start, max(date) End
from layoffs_staging;

-- Total laid off based on date
select substring(date,1,7) date, sum(total_laid_off) total_laid_off
from layoffs_staging
where date is not null and total_laid_off is not null
group by substring(date,1,7)
order by 1;